class Embeds::ReportsController < ApplicationController
  before_filter :load_report
  layout 'widget'

  def show
    @location = current_geo_location || Location.random.first
    @politicians = Politician.from_location(@location).in_office_normal_form.all(:limit => 8)
    @scores = @report.scores.for_politicians(@politicians).all
  end

  private

  def load_report
    @report =
      if params[:id] == 'random'
        Report.published.random.first
      else
        Report.published.find(Integer(params[:id]))
      end
  end
end
