class Reports::FollowsController < ApplicationController
  filter_access_to :all
  before_filter :load_report

  def show
    case params[:method].downcase
    when 'post'
      create
    when 'destroy'
      destroy
    else
      raise ArgumentError, "Invalid method #{params[:method]}"
    end
  end

  def create
    @follow = @report.follows.new(:user => current_user)
    if @follow.save
      flash[:success] = "You are now following '#{@report.name}'"
    else
      flash[:notice] = "You are already following '#{@report.name}'"
    end
    redirect_to params[:return_to] || report_path(@follow.report)
  end

  def destroy
    @follow = @report.follows.find_by_user_id(current_user.id)
    @follow.try(:destroy)
    flash[:success] = "You are no longer following '#{@report.name}'"
    redirect_to params[:return_to] || report_path(@follow.report)
  end
end
