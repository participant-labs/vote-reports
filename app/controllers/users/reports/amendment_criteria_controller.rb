class Users::Reports::AmendmentCriteriaController < ApplicationController
  filter_resource_access :nested_in => :reports
  before_filter :load_user
  before_filter :find_report, :only => [:index, :destroy]

  def new
    if !@user.friendly_id_status.best?
      redirect_to new_user_report_amendment_criterion_path(@user, @report), :status => 301
      return
    end
    @bill = Bill.find(params[:bill_id])
    @amendments = @bill.amendments.order('chamber, number').page(params[:page])

    render :partial => 'reports/amendment_criteria/table', :locals => {
      :report => @report, :bill => @bill, :amendments => @amendments
    }
  end

  def create
    if @report.update_attributes(params[:report].slice(:amendment_criteria_attributes))
      flash[:notice] = "Successfully updated report amendments."
      redirect_to edit_user_report_path(@user, @report, :anchor => 'Add_Bills')
    else
      render :action => 'new', :layout => false
    end
  end

  def index
    render :layout => false
  end

  def destroy
    @report.amendment_criteria.find(params[:id]).destroy
    flash[:notice] = "Successfully deleted amendment from report agenda"
    redirect_to edit_user_report_path(@user, @report, :anchor => 'Edit_Agenda')
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
