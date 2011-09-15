class InterestGroups::AmendmentCriteriaController < ApplicationController
  before_filter :load_interest_group
  before_filter :find_report
  filter_access_to :all, attribute_check: true, require: :edit, context: :interest_groups
  layout nil

  def new
    if request.path != new_interest_group_amendment_criterion_path(@interest_group)
      redirect_to new_interest_group_amendment_criterion_path(@interest_group), status: 301
      return
    end
    @bill = Bill.find(params[:bill_id])
    @amendments = @bill.amendments.order('chamber, number').page(params[:page])
  end

  def create
    if @report.update_attributes(params[:report].slice(:amendment_criteria_attributes))
      flash[:notice] = "Successfully updated interest group amendments."
      redirect_to edit_interest_group_path(@interest_group, anchor: 'Add_Bills')
    else
      render action: 'new'
    end
  end

  def index
  end

  def destroy
    @report.amendment_criteria.find(params[:id]).destroy
    flash[:notice] = "Successfully deleted amendment from agenda"
    redirect_to edit_interest_group_path(@interest_group, anchor: 'Edit_Agenda')
  end

  private

  def load_interest_group
    @interest_group = InterestGroup.find(params[:interest_group_id])
  end

  def find_report
    @report = @interest_group.report
  end

  def permission_denied_path
    interest_group_path(params[:interest_group_id])
  end
end
