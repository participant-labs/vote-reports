class Embeds::ReportsController < ApplicationController
  before_filter :load_report
  layout 'widget'

  def show
    @politicians = Politician.from_location(current_geo_location)
    @scores = @report.scores.for_politicians(@politicians).all(:limit => 7)
  end

  private

  def load_report
    @report = User.find(params[:user_id]).reports.find(params[:id])
  end
end
