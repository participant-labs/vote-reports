class Users::ReportsController < ApplicationController
  filter_resource_access :nested_in => :users

  def index
    @user = User.find(params[:user_id])
    @reports = @user.reports.published
  end

  def show
    @user = User.find(params[:user_id])
    @report = @user.reports.preload_bill_criteria.find(params[:id], :scope => @user)
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
    @user = User.find(params[:user_id])
    @report = @user.reports.find(params[:id], :scope => @user)
    if !@report.friendly_id_status.best?
      redirect_to edit_user_report_path(@user, @report), :status => 301
    end
  end

  def update
    @user = User.find(params[:user_id])
    @report = @user.reports.find(params[:id], :scope => @user)
    if @report.update_attributes(params[:report])
      flash[:notice] = "Successfully updated report."
      redirect_to [@user, @report]
    else
      render :action => 'edit'
    end
  end

  def new
    @user = User.find(params[:user_id])
    @report = @user.reports.build
  end

  def create
    @user = User.find(params[:user_id])
    @report = @user.reports.build(params[:report])
    if @report.save
      flash[:notice] = "Successfully created report."
      redirect_to new_user_report_bill_criteria_path(@user, @report, :new_report => true)
    else
      render :action => 'new'
    end
  end

  def destroy
    @user = User.find(params[:user_id])
    @user.reports.find(params[:id], :scope => @user).destroy
    flash[:notice] = "Successfully destroyed report."
    redirect_to user_reports_url(@user)
  end
end
