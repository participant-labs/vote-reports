class Users::Reports::BillsController < ApplicationController
  def new
    @report = current_user.reports.find(params[:report_id], :scope => current_user)
    if @report.has_better_id?
      redirect_to user_report_bills_path(current_user, @report), :status => 301
    end

    @bills = Bill.fetch_by_query(params[:q])
  end
end
