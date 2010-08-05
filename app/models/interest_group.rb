class InterestGroup < ActiveRecord::Base
  include HasReport

  has_ancestry
  has_friendly_id :name, :use_slug => true

  belongs_to :image
  def thumbnail
    image || build_image
  end

  searchable do
    text :name, :description
    string :name
    text :subjects do
      subjects.all(:select => 'name').map(&:name).join(' ')
    end
  end

  class << self
    def paginated_search(params)
      search do
        order_by :name
        fulltext params[:term]
        paginate :page => params[:page]
      end
    end
  end

  has_many :interest_group_subjects
  # The ReportSubject generator takes InterestGroupSubjects into account
  delegate :subjects, :to => :report

  has_many :reports, :class_name => 'InterestGroupReport' do
    def by_rated_on
      sort_by(&:rated_on).reverse
    end
  end

  has_many :ratings, :through => :reports
  def rated_politicians
    Politician.scoped(
      :select => 'DISTINCT politicians.*',
      :joins => {:ratings => :reports},
      :conditions => {:'reports.interest_group_id' => self})
  end

  named_scope :for_subjects, lambda {|subjects|
    if subjects.blank?
      {}
    else
      if subjects.first.is_a?(String)
        subjects = Subject.find(subjects)
      end
      {
        :select => 'DISTINCT interest_groups.*',
        :joins => :interest_group_subjects,
        :conditions => ['interest_group_subjects.subject_id IN(?)', subjects]
      }
    end
  }

  def phone_numbers
    [phone1, phone2].compact
  end

  def score_criteria
    reports + report.bill_criteria + report.amendment_criteria
  end

  def vote_smart_url
    "http://votesmart.org/issue_group_detail.php?sig_id=#{vote_smart_id}" if vote_smart_id
  end
end
