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
      :conditions => ['bill_criteria.report_id IN(?)', reports]
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

  named_scope :tag_cloud_for_interest_groups_matching, lambda {|query|
    result = {
      :joins => :interest_group_subjects,
      :select => 'DISTINCT(subjects.*), COUNT(interest_group_subjects.interest_group_id) AS count',
      :group => qualified_column_names,
      :order => "count DESC"
    }

    if query.present?
      interest_groups = InterestGroup.search do
        order_by :name
        fulltext query
      end.raw_results.map(&:primary_key)
      result.merge(:conditions => {:'interest_group_subjects.interest_group_id' => interest_groups})
    else
      result
    end
  }
end
