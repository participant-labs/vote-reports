class Report < ActiveRecord::Base
  belongs_to :user
  has_friendly_id :name, :use_slug => true, :scope => :user

  searchable do
    text :name, :description
    text :username do
      user.username
    end
    boolean :published do
      published?
    end
  end

  state_machine :initial => :personal do
    event :publish do
      transition :personal => :published
    end

    event :unpublish do
      transition :published => :personal
    end

    state :personal do
      def status
        "This report is personal, so it will not show up in lists or searches on this site. However, anyone can access it at this url."
      end

      def next_step
        if bill_criteria.blank?
          "You'll need to add bills to this report in order to publish this report."
        elsif scores.blank?
          "None of the added bills have passage roll call votes associated. You'll need to add a voted bill to publish this report."
        else
          notify_exceptional("Invalid publishable state for report #{inspect}") unless publishable?
          {
            :text => 'Publish this Report',
            :state_event => 'publish',
            :confirm => 'Publish this Report?  It will then show up in lists and searches on this site.'
          }
        end
      end
    end

    state :published do
      validates_presence_of :bill_criteria
      validates_presence_of :scores

      def status
        "This report is public, so it will show up in lists and searches on this site."
      end

      def next_step
        {
          :text => 'Unpublish this Report',
          :state_event => 'unpublish',
          :confirm => 'Unpublish this Report? It will no longer show up in lists or searches on this site.'
        }
      end
    end
  end

  class << self
    def per_page
      10
    end

    def paginated_search(params)
      search do
        fulltext params[:q]
        with(:published, true)
        paginate :page => params[:page], :per_page => Report.per_page
      end
    end
  end

  has_many :bill_criteria
  has_many :bills, :through => :bill_criteria

  has_many :scores, :class_name => 'ReportScore', :dependent => :destroy

  accepts_nested_attributes_for :bill_criteria, :reject_if => proc {|attributes| attributes['support'].nil? }

  validates_presence_of :user, :name

  named_scope :published, :conditions => {:state => 'published'}
  named_scope :unpublished, :conditions => "reports.state != 'published'"
  named_scope :with_criteria, :select => 'DISTINCT reports.*', :joins => :bill_criteria
  named_scope :scored, :select => 'DISTINCT reports.*', :joins => {:bill_criteria => {:bill => :passage_rolls}}
  named_scope :by_updated_at, :order => 'updated_at DESC'

  def description
    BlueCloth::new(self[:description].to_s).to_html
  end

  def publishable?
    return false unless can_publish?
    current_state_event = self.state_event
    self.state_event = "publish"
    result = self.valid?
    self.errors.clear
    self.state_event = current_state_event
    result
  end

  def image_path
 'http://images.ted.com/images/ted/conference/TED2010/speakers/over/kevin_bales-over.jpg'
  end

  def rescore!
    self.scores.clear
    bill_criteria.active.map(&:scores).flatten.group_by(&:politician).each_pair do |politician, bill_scores|
      bill_baseline = bill_scores.map(&:average_base)
      bill_baseline = bill_baseline.sum / bill_baseline.size

      scores = bill_scores.map {|s| s.score * s.average_base / bill_baseline }
      score = self.scores.create(:politician => politician, :score => scores.sum / scores.size)
      bill_scores.each do |bill_score|
        bill_score.votes.each do |vote|
          score.evidence.create(:vote => vote, :bill_criterion => bill_score.bill_criterion)
        end
      end
    end
    unpublish if self.scores.empty? && can_unpublish?
    nil
  end
end
