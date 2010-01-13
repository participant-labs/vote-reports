class SiteController < ApplicationController

  def index
    @recent_reports = Report.scored.by_updated_at.all(:limit => Report::PER_PAGE) \
                            .paginate(:per_page => Report::PER_PAGE)
  end

  def about
  end

end
