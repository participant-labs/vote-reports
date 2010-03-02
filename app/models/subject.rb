class Subject < ActiveRecord::Base
  has_many :bill_subjects
  has_many :bills, :through => :bill_subjects

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
    Report.scoped(
      :select => 'DISTINCT reports.*',
      :joins => {:bills => :bill_subjects},
      :conditions => {:'bill_subjects.subject_id' => self})
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
end
