class Reports::ScoresController < ApplicationController
  def show
    @report = Report.find(params[:report_id])
    @score = @report.scores.find(params[:id])
    render :action => 'show', :layout => false
  end
end
