class SiteController < ApplicationController

  def index
    params[:in_office] = true

    @recent_reports = Report.user_published.by_created_at.all(:limit => 3)

    @politicians =
      if shown_location
        sought_politicians.scoped(:limit => 5)
      else
        Politician.in_office.scoped(:limit => 5)
      end
    @scores =  @politicians.map {|politician| politician.report_scores.published.first(:order => 'random()') }.compact

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'scores/list', :locals => {:scores => @scores}
      }
    end
  end

  def about
  end
end
