class Report < ActiveRecord::Base
  belongs_to :user
  has_friendly_id :name, :use_slug => true, :scope => :user

  searchable do
    text :name, :description
    text :username do
      user.username
    end
  end

  class << self
    def per_page
      10
    end

    def paginated_search(params)
      search do
        fulltext params[:q]
        paginate :page => params[:page], :per_page => Report.per_page
      end
    end
  end

  has_many :bill_criteria
  has_many :bills, :through => :bill_criteria

  has_many :scores, :class_name => 'ReportScore', :dependent => :destroy, :order => 'score DESC'

  accepts_nested_attributes_for :bill_criteria, :reject_if => proc {|attributes| attributes['support'].nil? }

  validates_presence_of :user, :name

  named_scope :published, :select => 'DISTINCT reports.*', :joins => :bill_criteria
  named_scope :scored, :select => 'DISTINCT reports.*', :joins => {:bill_criteria => {:bill => :rolls}}
  named_scope :by_updated_at, :order => 'updated_at DESC'

  def description
    BlueCloth::new(self[:description].to_s).to_html
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
  end
end
