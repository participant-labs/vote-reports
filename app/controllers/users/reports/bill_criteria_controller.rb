class Users::Reports::BillCriteriaController < ApplicationController
  filter_resource_access :nested_in => :reports
  before_filter :find_report, :only => [:index, :destroy]

  def new
    @new_report = true if params[:new_report]
    @report = current_user.reports.find(params[:report_id], :scope => current_user)
    if !@report.friendly_id_status.best?
      redirect_to new_user_report_bill_criterion_path(current_user, @report), :status => 301
      return
    end
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

  def create
    @report = current_user.reports.find(params[:report_id], :scope => current_user)
    if @report.update_attributes(params[:report].slice(:bill_criteria_attributes))
      flash[:notice] = "Successfully updated report bills."
      redirect_to :action => 'new'
    else
      render :action => 'new'
    end
  end

  def index
  end

  def destroy
    @report.bill_criteria.find(params[:id]).destroy
    flash[:notice] = "Successfully deleted report criterion"
    redirect_to :back
  end

  private

  def find_report
    @report = current_user.reports.find(params[:report_id], :scope => current_user)
  end

  def permission_denied_path
    user_report_path(params[:user_id], params[:report_id])
  end
end
