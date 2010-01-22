class SiteController < ApplicationController

  def index
    @recent_reports = Report.scored.by_updated_at.paginate(:page => params[:page])
  end

  def about
  end

end
