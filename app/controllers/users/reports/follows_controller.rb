class Users::Reports::FollowsController < ApplicationController
  before_filter :login_required

  def create
    @follow = User.find(params[:user_id]).reports.find(params[:report_id]).follows.new(:user => current_user)
    if @follow.save
      flash[:success] = "You are now following this report"
    else
      flash[:notice] = "You are already following this report"
    end
    redirect_to user_report_path(@follow.report.user, @follow.report)
  end
end
