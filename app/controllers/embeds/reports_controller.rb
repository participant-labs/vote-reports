class Embeds::ReportsController < ApplicationController
  before_filter :load_report
  layout 'widget'

  def show
    @politicians = Politician.from_location(current_geo_location).in_office_normal_form.all(:limit => 7)
    @scores = @report.scores.for_politicians(@politicians).all
  end

  private

  def load_report
    @user = User.find(params[:user_id])
    @report = @user.reports.find(params[:id])
  end
end
