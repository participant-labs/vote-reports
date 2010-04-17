class SiteController < ApplicationController

  def index
    @dont_show_geo_address = true
    params[:in_office] = true

    @politicians = sought_politicians

    @recent_reports = Report.user_published.by_updated_at.all(:limit => 3)
    @featured_interest_group_reports = Report.interest_group_published.random.all(:limit => 3)
  end

  def about
  end
end
