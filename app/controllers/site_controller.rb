class SiteController < ApplicationController

  def index
    params[:in_office] = true

    @politicians =
      if shown_location
        sought_politicians
      else
        Politician.in_office
      end.scoped(:limit => 6)
    @sample_report = Report.published.with_scores_for(@politicians).random.first
    @scores = @sample_report.scores.for_politicians(@politicians)

    @recent_reports = Report.user_published.by_created_at.all(:limit => 3)
  end

  def about
  end
end
