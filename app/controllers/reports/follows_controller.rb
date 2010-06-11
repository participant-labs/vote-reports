class Reports::FollowsController < ApplicationController
  filter_access_to :all
  before_filter :load_report

  def show
    if params[:method] == 'post'
      create
    elsif params[:method] == 'destroy'
      destroy
    else
      raise ActiveResource::InvalidRequestError
    end
  end

  def create
    @follow = @report.follows.new(:user => current_user)
    if @follow.save
      flash[:success] = "You are now following this report"
    else
      flash[:notice] = "You are already following this report"
    end
    redirect_to report_path(@follow.report)
  end

  def destroy
    @follow = @report.follows.find_by_user_id(current_user.id)
    @follow.try(:destroy)
    flash[:success] = "You are no longer following this report"
    redirect_to report_path(@follow.report)
  end
end
