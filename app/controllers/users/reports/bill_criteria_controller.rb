class Users::Reports::BillCriteriaController < ApplicationController
  filter_resource_access nested_in: :reports
  before_filter :load_user
  before_filter :find_report, only: [:index, :destroy]

  def new
    @new_report = true if params[:new_report]
    @report = @user.reports.find(params[:report_id])
    @bills = Bill.paginated_search(params)

    @current = params[:current]
    @voted = params[:voted]

    respond_to do |format|
      format.html {
        render layout: false
      }
      format.js {
        render partial: 'reports/bill_criteria/table', locals: {
          report: @report, bills: @bills
        }
      }
    end
  end

  def create
    @report = @user.reports.find(params[:report_id])
    if @report.update_attributes(params[:report].slice(:bill_criteria_attributes))
      flash[:notice] = "Successfully updated report bills."
      redirect_to edit_user_report_path(@user, @report, anchor: 'Add_Bills')
    else
      render action: 'new', layout: false
    end
  end

  def index
    render layout: false
  end

  def destroy
    @report.bill_criteria.find(params[:id]).destroy
    flash[:notice] = "Successfully deleted report criterion"
    redirect_to edit_user_report_path(@user, @report, anchor: 'Edit_Agenda')
  end

  private

  def load_user
    @user = User.find(params[:user_id])
  end

  def find_report
    @report = @user.reports.find(params[:report_id])
  end

  def permission_denied_path
    user_report_path(params[:user_id], params[:report_id])
  end
end
