class SiteController < ApplicationController

  def index
    @recent_reports = Report.recent
  end

  def about
  end

end
