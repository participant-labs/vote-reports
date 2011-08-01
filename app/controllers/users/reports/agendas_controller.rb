class Users::Reports::AgendasController < ApplicationController
  caches_page :show

  def show
    @user = User.find(params[:user_id])
    @report = @user.reports.includes([:user, :bill_criteria]).find(params[:report_id])
    render :layout => false
  end
end
