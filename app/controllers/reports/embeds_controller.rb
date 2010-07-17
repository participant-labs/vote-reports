class Reports::EmbedsController < ApplicationController
  layout nil

  def show
    @report = User.find(params[:user_id]).reports.find(params[:report_id])
  end
end
