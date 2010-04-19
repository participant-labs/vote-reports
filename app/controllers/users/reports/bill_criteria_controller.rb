class Users::Reports::BillCriteriaController < ApplicationController
  before_filter :is_report_owner
  filter_access_to :all

  def new
    @new_report = true if params[:new_report]
    @report = current_user.reports.find(params[:report_id], :scope => current_user)
    if !@report.friendly_id_status.best?
      redirect_to new_user_report_bill_criteria_path(current_user, @report), :status => 301
      return
    end
    @q = params[:q]
    @bills = Bill.paginated_search(params).results

    @current = params[:current]
    @voted = params[:voted]

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'users/reports/bill_criteria/table', :locals => {
          :report => @report, :bills => @bills
        }
      }
    end
  end

  def index
    @report = current_user.reports.find(params[:report_id], :scope => current_user)
  end

  def destroy
    @report = current_user.reports.find(params[:report_id], :scope => current_user)
    @report.bill_criteria.find(params[:id]).destroy
    flash[:notice] = "Successfully deleted report criterion"
    redirect_to :back
  end
end
