class SiteController < ApplicationController

  def index
    @recent_reports = Report.recent.published
  end

  def about
  end

  def exceptional_test
    Politician.new.headshot_url
  end

end
