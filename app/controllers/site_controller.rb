class SiteController < ApplicationController

  def index
    @recent_reports = Report.scored.by_updated_at.all(:limit => Report.per_page).paginate
  end

  def about
  end

end
