class Reports::BillCriteriaController < ApplicationController
  filter_access_to :all

  def autofetch
    @report = Report.find_by_id(params[:report_id])
    unless @report
      raise ActiveRecord::RecordNotFound.new("No report for #{params[:report_id]}")
    end
    @criteria = @report.bill_criteria.autofetch_from!(params[:source])
    @bills = @criteria.map(&:bill)

    render :partial => 'reports/bill_criteria/table', :locals => {
      :report => @report, :bills => @bills
    }
  end
end