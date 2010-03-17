class Users::Reports::FollowsController < ApplicationController
  before_filter :login_required

  def create
    User.find(params[:user_id]).reports.find(params[:report_id]).follows.create!(:user => current_user)
    flash[:success] = "You are now following this report"
    redirect_to :back
  end
end
