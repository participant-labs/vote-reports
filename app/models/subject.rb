class Subject < ActiveRecord::Base
  has_many :bill_subjects
  has_many :bills, :through => :bill_subjects

  def reports
    Report.scoped(
      :joins => {:bills => :bill_subjects},
      :conditions => {:'bill_subjects.subject_id' => self})
  end

  named_scope :for_report, lambda {|reports|
    {
      :joins => {:bills => :reports},
      :conditions => {:'reports.id' => reports}
    }
  }

  named_scope :for_tag_cloud,
    :select => "subjects.*, COUNT(bills.id) AS count",
    :group => "subjects.id, subjects.name",
    :order => 'count DESC'

  named_scope :by_popularity,
    :joins => :bill_subjects,
    :select => "DISTINCT(subjects.*), COUNT(bill_subjects.bill_id) AS count",
    :group => "subjects.id, subjects.name",
    :order => "count DESC"

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
  end
end
