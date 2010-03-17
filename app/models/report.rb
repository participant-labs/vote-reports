class Report < ActiveRecord::Base
  DEFAULT_THUMBNAIL_PATH = "reports/default_thumbnail.jpg"

  belongs_to :user
  has_friendly_id :name, :use_slug => true, :scope => :user

  has_many :report_delayed_jobs
  has_many :delayed_jobs, :through => :report_delayed_jobs do
    def failing
      scoped(:conditions => 'delayed_jobs.last_error IS NOT NULL')
    end

    def passing
      scoped(:conditions => {:last_error => nil})
    end

    def unlocked
      scoped(:conditions => {:locked_at => nil})
    end
  end

  def subjects
    Subject.for_report(self)
  end

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
        "This report is published, so it will show up in lists and searches on this site."
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

  has_many :bill_criteria, :dependent => :destroy
  has_many :bills, :through => :bill_criteria

  has_many :follows, :class_name => 'ReportFollow'
  has_many :followers, :through => :follows, :source => :user

  has_many :scores, :class_name => 'ReportScore', :dependent => :destroy

  has_attached_file :thumbnail,
        :styles => { :normal => "330x248>",
                     :thumbnail => '110x83#',
                     :small => "55x41#" },
        :processors => [:jcropper],
        :default_url => ('/images/' + DEFAULT_THUMBNAIL_PATH),
        :default_style => :thumbnail

  validate :name_not_reserved
  validates_attachment_content_type :thumbnail, :content_type => ['image/jpeg', 'image/pjpeg', 'image/jpg', 'image/png', 'image/gif', 'image/x-png']

  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h

  before_validation_on_create :add_creator_to_followers
  after_update :reprocess_thumbnail, :if => :cropping?

  accepts_nested_attributes_for :bill_criteria, :reject_if => proc {|attributes| attributes['support'].nil? }

  validates_presence_of :user, :name, :followers

  named_scope :published, :conditions => {:state => 'published'}
  named_scope :unpublished, :conditions => "reports.state != 'published'"
  named_scope :with_criteria, :select => 'DISTINCT reports.*', :joins => :bill_criteria
  named_scope :scored, :select => 'DISTINCT reports.*', :joins => {:bill_criteria => {:bill => :passage_rolls}}
  named_scope :by_updated_at, :order => 'updated_at DESC'

  named_scope :with_subjects, lambda {|subjects|
    subjects = Array(subjects)
    if subjects.first.is_a?(String)
      {
        :select => 'DISTINCT reports.*',
        :joins => {:bills => :subjects},
        :conditions => ["subjects.name IN(:subjects) OR subjects.cached_slug IN(:subjects)",
          {:subjects => subjects}]
      }
    else
      {
        :select => 'DISTINCT reports.*',
        :joins => {:bills => :bill_subjects},
        :conditions => {:'bill_subjects.subject_id' => subjects}
      }
    end
  }

  named_scope :with_scores_for, lambda {|politicians|
    if politicians.blank?
      {}
    else
      {
        :select => 'DISTINCT reports.*',
        :joins => :scores,
        :conditions => {:'report_scores.politician_id' => politicians}
      }
    end
  }

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

  def rescore!
    unless delayed_jobs.unlocked.present?
      delayed_jobs << Delayed::Job.enqueue(Report::Scorer.new(id))
    end
  end

  def cropping?
    [crop_x, crop_y, crop_w, crop_h].all?(&:present?)
  end

  # helper method used by the cropper view to get the real image geometry
  def thumbnail_geometry(style = :original)
    @geometry ||= {}
    path = thumbnail.path(style)
    if path.present?
      @geometry[style] ||= Paperclip::Geometry.from_file path
    else
      @default_geometry ||= Paperclip::Geometry.from_file Rails.root.join('public/images', DEFAULT_THUMBNAIL_PATH)
    end
  end

private

  def add_creator_to_followers
    if user
      self.followers << user
    end
  end

  def reprocess_thumbnail
    thumbnail.reprocess!
  end

  def name_not_reserved
    if %w[new edit].include?(name.to_s.downcase)
      errors.add(:name, "is reserved")
    end
  end
end
