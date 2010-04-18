class SiteController < ApplicationController

  def index
    @dont_show_geo_address = true
    params[:in_office] = true

    @politicians = sought_politicians.scoped(:limit => 5)
    @scores =  @politicians.map {|politician| politician.report_scores.published.first(:order => 'random()') }.compact
    if @scores.empty?
      @politicians = Politician.in_office(true).scoped(:limit => 5)
      @scores =  @politicians.map {|politician| politician.report_scores.published.first(:order => 'random()') }.compact
    end

    @recent_reports = Report.user_published.by_updated_at.all(:limit => 3)
    @featured_interest_group_reports = Report.interest_group_published.random.all(:limit => 3)
  end

  def about
  end
end
