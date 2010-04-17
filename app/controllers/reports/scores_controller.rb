class Reports::ScoresController < ApplicationController
  def show
    @report = Report.find(params[:report_id])
    @score = @report.scores.find(params[:id])
    render :layout => false
  end
end
