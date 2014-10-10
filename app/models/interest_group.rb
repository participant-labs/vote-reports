class InterestGroup < ActiveRecord::Base
  include HasReport
  extend FriendlyId
  friendly_id :name, use: [:slugged, :history]

  has_ancestry

  belongs_to :owner, class_name: 'User'

  searchable do
    text :name, :description
    string :name
    text :subjects do
      subjects.all(select: 'name').map(&:name).join(' ')
    end
  end

  class << self
    def paginated_search(params)
      search do
        order_by :name
        fulltext params[:term]
        paginate page: params[:page]
      end
    end
  end

  has_many :interest_group_subjects
  # The ReportSubject generator takes InterestGroupSubjects into account
  delegate :subjects, to: :report

  has_many :reports, class_name: 'InterestGroupReport' do
    def by_rated_on
      sort_by(&:rated_on).reverse
    end
  end

  has_many :ratings, through: :reports
  def rated_politicians
    Politician.select('DISTINCT politicians.*').joins(:interest_group_reports).where(:'interest_group_reports.interest_group_id' => self)
  end

  scope :ratings_not_recently_updated, -> {
    where(['interest_groups.ratings_updated_at IS NULL OR interest_groups.ratings_updated_at < ?', 1.month.ago])
  }

  scope :for_display, -> { includes([:image, {report: [:top_subject]}]) }

  scope :vote_smart, -> { where('interest_groups.vote_smart_id is not null') }

  scope :for_subjects, ->(subjects) {
    if subjects.blank?
      all
    else
      if subjects.first.is_a?(String)
        subjects = Subject.find(subjects)
      end
      select('DISTINCT interest_groups.*').joins(:interest_group_subjects)\
        .where(['interest_group_subjects.subject_id IN(?)', subjects])
    end
  }

  def calibrate_ratings
    reports.each do |report|
      report.calibrate_ratings
    end
  end

  def domain
    @domain ||=
      if website_url.present?
        URI.parse(website_url).host.split('.').reject {|s| s == 'www' }.join('.')
      elsif email.present?
        email.split('@').last
      end
  end

  def phone_numbers
    [phone1, phone2].compact
  end

  def score_criteria
    reports + report.bill_criteria + report.amendment_criteria
  end

  def vote_smart_url
    "http://votesmart.org/interest-group/#{vote_smart_id}" if vote_smart_id
  end

  def full_address
    "#{address}, #{city}, #{state} #{zip}"
  end

  def as_json(opts = {})
    super opts.reverse_merge(only: [:name, :description, :id, :vote_smart_id, :website_url, :email, :address, :state, :zip, :phone1, :phone2, :fax], methods: [:to_param, :url])
  end
end
