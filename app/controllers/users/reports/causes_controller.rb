class Users::Reports::CausesController < ApplicationController
  def index
    @user = User.find(params[:user_id])
    @report = @user.reports.find(params[:report_id], :scope => @user, :include => :causes)
    @causes = @report.causes.paginate :page => params[:page]
    render :layout => false
  end
end
