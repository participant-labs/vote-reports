class Reports::BillCriteriaController < ApplicationController
  filter_access_to :all

  def autofetch
    @report = Report.friendly.find(params[:report_id])
    @criteria = @report.bill_criteria.autofetch_from!(params[:source])

    render partial: 'reports/bill_criteria/table', locals: {
      report: @report, criteria: @criteria
    }
  end
end
