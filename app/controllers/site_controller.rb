class SiteController < ApplicationController

  def index
    @recent_reports = Report.recent.scored
  end

  def about
  end

end
