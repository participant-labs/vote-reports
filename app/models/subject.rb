class Subject < ActiveRecord::Base
  extend FriendlyId
  friendly_id :name, use: :slugged

  has_many :bill_subjects
  has_many :bills, through: :bill_subjects

  has_many :interest_group_subjects
  has_many :interest_groups, through: :interest_group_subjects

  has_many :report_subjects
  has_many :reports, through: :report_subjects

  searchable do
    text :name
    boolean :visible do
      true
    end
    boolean :autocompletable do
      true
    end
  end

  class << self
    def paginated_search(params)
      search do
        fulltext params[:term]
        paginate page: params[:subject_page]
      end
    end

    def qualified_column_names
      column_names.collect {|c| "subjects.#{c}"}.join(",")
    end
  end

  def reports
    Report.with_subjects(self)
  end

  scope :for_bill_criteria_on_report, ->(reports) {
    joins(bills: :bill_criteria).where(['bill_criteria.report_id IN(?)', reports])
  }

  scope :for_report, ->(reports) {
    joins(:report_subjects).where(['report_subjects.report_id IN(?)', reports])
  }

  scope :on_published_reports, -> {
    joins(:reports).where(["reports.state = ? OR reports.interest_group_id IS NOT NULL", 'published'])
  }

  scope :for_tag_cloud, -> {
    select("DISTINCT(subjects.*), SUM(report_subjects.count) AS count")\
    .group(qualified_column_names)\
    .order('count DESC')
  }

  scope :by_popularity, -> {
    joins(:bill_subjects)\
    .select("DISTINCT(subjects.*), SUM(report_subjects.count) AS count")\
    .group(qualified_column_names)\
    .order("count DESC")
  }

  scope :tag_cloud_for_interest_groups_matching, ->(query) {
    result = joins(:interest_group_subjects)\
      .select('DISTINCT(subjects.*), COUNT(interest_group_subjects.interest_group_id) AS count')\
      .group(qualified_column_names)\
      .order("count DESC")

    if query.present?
      interest_groups = InterestGroup.search do
        order_by :name
        fulltext query
      end.raw_results.map(&:primary_key)
      result.where(:'interest_group_subjects.interest_group_id' => interest_groups)
    else
      result
    end
  }

  def as_json(opts)
    super(opts.reverse_merge(only: [:name, :vote_smart_id, :name], methods: :to_param))
  end
end
