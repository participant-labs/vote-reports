class Users::Reports::BillsController < ApplicationController
  def new
    @report = current_user.reports.find(params[:report_id])
    @bills = Bill.fetch_by_query(params[:q])
  end
end
