class Subject < ActiveRecord::Base
  has_many :bill_subjects
  has_many :bills, :through => :bill_subjects

  has_many :interest_group_subjects
  has_many :interest_groups, :through => :interest_group_subjects

  has_friendly_id :name, :use_slug => true

  searchable do
    text :name
  end

  class << self
    def paginated_search(params)
      search do
        fulltext params[:q]
        paginate :page => params[:subject_page]
      end
    end

    def qualified_column_names
      column_names.collect {|c| "subjects.#{c}"}.join(",")
    end
  end

  def reports
    Report.with_subjects(self)
  end

  named_scope :for_report, lambda {|reports|
    {
      :joins => {:bills => :bill_criteria},
      :conditions => {:'bill_criteria.report_id' => reports}
    }
  }

  named_scope :on_published_reports,
    :joins => {:bills => :reports},
    :conditions => {:'reports.state' => 'published'}

  named_scope :for_tag_cloud,
    :select => "DISTINCT(subjects.*), COUNT(bills.id) AS count",
    :group => qualified_column_names,
    :order => 'count DESC'

  named_scope :by_popularity,
    :joins => :bill_subjects,
    :select => "DISTINCT(subjects.*), COUNT(bill_subjects.bill_id) AS count",
    :group => qualified_column_names,
    :order => "count DESC"

  named_scope :for_interest_groups_tag_cloud,
    :joins => :interest_group_subjects,
    :select => 'DISTINCT(subjects.*), COUNT(interest_group_subjects.interest_group_id) AS count',
    :group => qualified_column_names,
    :order => "count DESC"
end
