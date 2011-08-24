class InterestGroups::BillCriteriaController < ApplicationController
  filter_resource_access :nested_in => :interest_groups
  before_filter :find_report
  cache_sweeper :bill_criterion_sweeper, :only => [:create, :destroy]

  def new
    @new_report = true if params[:new_report]
    if request.path != new_interest_group_bill_criterion_path(@interest_group)
      redirect_to new_interest_group_bill_criterion_path(@interest_group), :status => 301
      return
    end
    @bills = Bill.paginated_search(params)

    @current = params[:current]
    @voted = params[:voted]

    respond_to do |format|
      format.html {
        render :layout => false
      }
      format.js {
        render :partial => 'reports/bill_criteria/table', :locals => {
          :report => @report, :bills => @bills
        }
      }
    end
  end

  def create
    @report.update_attributes!(params[:report].slice(:bill_criteria_attributes))
    flash[:notice] = "Successfully updated interest group bills."
    redirect_to edit_interest_group_path(@interest_group, :anchor => 'Add_Bills')
  end

  def index
    render :layout => false
  end

  def destroy
    @report.bill_criteria.find(params[:id]).destroy
    flash[:notice] = "Successfully deleted interest group bill criterion"
    redirect_to edit_interest_group_path(@interest_group, :anchor => 'Edit_Agenda')
  end

  private

  def find_report
    @report = @interest_group.report
  end

  def permission_denied_path
    interest_group_path(params[:interest_group_id])
  end
end
