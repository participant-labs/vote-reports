class Users::Reports::ScoresController < ApplicationController
  def show
    @user = User.find(params[:user_id])
    @report = @user.reports.find(params[:report_id], :scope => @user)
    @score = @report.scores.find(params[:id])
    render :layout => false
  end
end
