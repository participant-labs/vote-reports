class Users::Reports::FollowsController < ApplicationController
  filter_access_to :all

  def create
    @follow = User.find(params[:user_id]).reports.find(params[:report_id]).follows.new(:user => current_user)
    if @follow.save
      flash[:success] = "You are now following this report"
    else
      flash[:notice] = "You are already following this report"
    end
    redirect_to :back
  end
  alias_method :show, :create
end
