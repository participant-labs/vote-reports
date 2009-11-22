class ReportsController < ApplicationController
  before_filter :login_required

  def new
    redirect_to new_user_report_path(current_user)
  end

  def show
    redirect_to user_report_path(current_user, Report.find(params[:id]))
  end

  def edit
    redirect_to edit_user_report_path(current_user, Report.find(params[:id]))
  end
end