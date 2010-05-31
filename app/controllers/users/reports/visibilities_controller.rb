class Users::Reports::VisibilitiesController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    @report = @user.reports.find(params[:report_id], :scope => @user)
    render :layout => false
  end
end
