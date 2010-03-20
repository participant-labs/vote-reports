class ReportCriterion < ActiveRecord::Base
  belongs_to :report
  belongs_to :criteria_report, :class_name => 'Report'

  validates_presence_of :report, :criteria_report
  validate :reports_are_different

private

  def reports_are_different
    if report_id == criteria_report_id
      errors.add_to_base("A report can not have itself as a criteria")
    end
  end
end
