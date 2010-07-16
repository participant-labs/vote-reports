class SiteController < ApplicationController

  def index
    params[:in_office] = true

    @politicians =
      if shown_location
        sought_politicians.scoped(:limit => 5)
      else
        Politician.in_office.scoped(:limit => 5)
      end
    @scores =  @politicians.map {|politician| politician.report_scores.published.first(:order => 'random()') }.compact
    @recent_reports = Report.user_published.by_created_at.all(:limit => @scores.size)
  end

  def about
  end
end
