class SiteController < ApplicationController

  def index
    @recent_reports = Report.recent.published
  end

  def about
  end

  def exceptional_test
    Vote.fetch_for_bill(nil)
  end

end
