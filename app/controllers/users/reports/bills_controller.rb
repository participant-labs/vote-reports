class Users::Reports::BillsController < ApplicationController
  before_filter :is_report_owner

  def new
    @report = current_user.reports.find(params[:report_id], :scope => current_user)
    if @report.has_better_id?
      redirect_to new_user_report_bills_path(current_user, @report), :status => 301
    end
    @q = params[:q]
    @bills = Bill.paginated_search(params).results
  end

  def destroy
    @report = current_user.reports.find(params[:report_id], :scope => current_user)
    @report.bill_criteria.find_by_bill_id(Bill.find(params[:id])).destroy
    flash[:notice] = "Successfully deleted report criterion"
    redirect_to :back
  end
end
