class Reports::BillsController < ApplicationController
  def new
    @report = current_user.reports.find(params[:report_id])
    @bills = Bill.find_by_query(params[:q])
  end
end
