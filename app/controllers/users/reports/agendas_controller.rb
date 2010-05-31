class Users::Reports::AgendasController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    @report = @user.reports.find(params[:report_id], :scope => @user, :include => [:user, :bill_criteria])
    render :layout => false
  end
end
