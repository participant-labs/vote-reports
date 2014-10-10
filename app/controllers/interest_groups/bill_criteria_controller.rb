class InterestGroups::BillCriteriaController < ApplicationController
  filter_access_to :all
  before_filter :find_report

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
    @report.update_attributes!(params[:report].slice(:bill_criteria_attributes))
    flash[:notice] = "Successfully updated interest group bills."
    redirect_to edit_interest_group_path(@interest_group, anchor: 'Add_Bills')
  end

  def index
    render layout: false
  end

  def destroy
    @report.bill_criteria.find(params[:id]).destroy
    flash[:notice] = "Successfully deleted interest group bill criterion"
    redirect_to edit_interest_group_path(@interest_group, anchor: 'Edit_Agenda')
  end

  private

  def find_report
    @interest_group = InterestGroup.find(params[:interest_group_id])
    @report = @interest_group.report
  end

  def permission_denied_path
    interest_group_path(params[:interest_group_id])
  end
end
