class Cause < ActiveRecord::Base
  include HasReport

  has_many :cause_reports
  has_many :reports, :through => :cause_reports

  has_many :issue_causes
  has_many :issues, :through => :issue_causes

  named_scope :without_issue,
    :joins => 'LEFT OUTER JOIN issue_causes ON issue_causes.cause_id = causes.id',
    :conditions => {:'issue_causes.issue_id' => nil}

  def report_subjects
    ReportSubject.scoped(:conditions => {:report_id => reports})
  end

  accepts_nested_attributes_for :cause_reports, :reject_if => proc {|attributes| attributes['support'] == '0' }

  has_friendly_id :name, :use_slug => true

  validates_presence_of :description

  alias_method :score_criteria, :cause_reports

  class << self
    def per_page
      20
    end
  end
end
