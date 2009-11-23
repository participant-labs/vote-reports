class ReportsController < ApplicationController
  before_filter :login_required, :except => [:show, :index]

  def new
    redirect_to new_user_report_path(current_user)
  end

  def index
    @recent_reports = Report.recent.published
  end

  def show
    report = Report.find(params[:id])
    redirect_to user_report_path(report.user, report)
  end

  def edit
    report = Report.find(params[:id])
    redirect_to edit_user_report_path(report.user, report)
  end
end
