class Embeds::ReportsController < ApplicationController
  before_filter :load_report
  layout 'widget'

  def show
    @congressional_district = (
      session[:geo_location] ? District.lookup(session[:geo_location]) : District.random
    ).federal.first.congressional_district
    @politicians = Politician.from_congressional_district(@congressional_district)
    @scores = @report.scores.for_politicians(@politicians).paginate :page => params[:page], :per_page => 3
  end

  private

  def load_report
    @report = User.find(params[:user_id]).reports.find(params[:id])
  end
end
