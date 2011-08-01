class Users::Reports::CausesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @report = @user.reports.includes(:causes).find(params[:report_id])
    @causes = @report.causes.page(params[:page])
    render :layout => false
  end
end
