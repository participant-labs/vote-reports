class SiteController < ApplicationController

  def index
    @recent_reports = Report.recent.published
  end

  def about
  end

end
