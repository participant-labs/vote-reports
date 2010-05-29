module CausesHelper
  def build_cause_reports_for(cause, reports)
    reports.map do |report|
      cause.cause_reports.find_or_initialize_by_report_id(report.id)
    end
  end
end
