class Users::Reports::BillCriteriaController < ApplicationController
  filter_resource_access nested_in: :reports

  def new
    @new_report = true if params[:new_report]
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

  protected

  def load_report
    @user = User.friendly.find(params[:user_id])
    @report = @user.reports.friendly.find(params[:report_id])
  end

  private

  def permission_denied_path
    user_report_path(params[:user_id], params[:report_id])
  end
end
