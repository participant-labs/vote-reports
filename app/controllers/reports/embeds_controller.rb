class Reports::EmbedsController < ApplicationController
  before_filter :load_report
  layout nil

  def show
    @scores = @report.scores.for_politicians(sought_politicians)
  end

  private

  def load_report
    @report = User.find(params[:user_id]).reports.find(params[:report_id])
  end
end
