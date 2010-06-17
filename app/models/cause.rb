class Cause < ActiveRecord::Base
  include HasReport

  has_many :cause_reports
  has_many :reports, :through => :cause_reports

  def report_subjects
    ReportSubject.scoped(:conditions => {:report_id => reports})
  end

  accepts_nested_attributes_for :cause_reports, :reject_if => proc {|attributes| attributes['support'] == '0' }

  has_friendly_id :name, :use_slug => true

  validates_presence_of :description

  delegate :rescore!, :to => :report

  alias_method :score_criteria, :cause_reports

  class << self
    def per_page
      20
    end
  end
end
