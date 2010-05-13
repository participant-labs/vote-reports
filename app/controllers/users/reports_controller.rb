class Users::ReportsController < ApplicationController
  filter_resource_access :nested_in => :users
  before_filter :find_user
  before_filter :find_report, :only => [:show, :edit, :update, :destroy]

  def index
    @reports = @user.reports.published
  end

  def show
    if !@report.friendly_id_status.best?
      redirect_to user_report_path(@user, @report), :status => 301
      return
    end

    @scores = @report.scores.for_politicians(sought_politicians)
    @subjects = @report.subjects.for_tag_cloud.all(
    :select => "DISTINCT(subjects.*), SUM(report_subjects.count) AS count",
    :limit => 30)

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'reports/scores/table', :locals => {
          :report => @report, :scores => @scores
        }
      }
    end
  end

  def edit
    if !@report.friendly_id_status.best?
      redirect_to edit_user_report_path(@user, @report), :status => 301
    end
  end

  def update
    if @report.update_attributes(params[:report])
      flash[:notice] = "Successfully updated report."
      redirect_to [@user, @report]
    else
      render :action => 'edit'
    end
  end

  def new
    @report = @user.reports.build
  end

  def create
    @report = @user.reports.build(params[:report])
    if @report.save
      flash[:notice] = "Successfully created report."
      redirect_to new_user_report_bill_criterion_path(@user, @report, :new_report => true)
    else
      render :action => 'new'
    end
  end

  def destroy
    @report.destroy
    flash[:notice] = "Successfully destroyed report."
    redirect_to user_reports_path(@user)
  end

  private

  def permission_denied_path
    if permitted_to?(:show, @report, :context => :users_reports)
      user_report_path(params[:user_id], params[:id])
    else
      user_reports_path(params[:user_id])
    end
  end

  def find_user
    @user = User.find(params[:user_id])
  end

  def find_report
    @report = @user.reports.find(params[:id], :scope => @user)
  end
end
