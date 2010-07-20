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

    respond_to do |format|
      format.html {
        @recent_reports = Report.user_published.by_created_at.all(:limit => 3)
      }
      format.js {
        render :partial => 'reports/report_and_scores', :locals => {
          :report => @sample_report,
          :scores => @scores
        }
      }
    end
  end

  def about
  end
end
