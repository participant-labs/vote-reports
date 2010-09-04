class Reports::EmbedsController < ApplicationController
  before_filter :load_report
  layout nil

  def show
  end

  private

  def load_report
    @report =
      if params[:user_id]
        User.find(params[:user_id]).reports.find(params[:report_id])
      elsif params[:interest_group_id]
        InterestGroup.find(params[:interest_group_id]).report
      elsif params[:cause_id]
        Cause.find(params[:cause_id]).report
      end
  end
end
