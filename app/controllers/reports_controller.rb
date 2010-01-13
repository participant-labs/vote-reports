class ReportsController < ApplicationController
  before_filter :login_required, :except => [:index]

  def new
    redirect_to new_user_report_path(current_user)
  end

  def index
    if @q = params[:q]
      @title = 'Matching Reports'
      @reports = Report.paginated_search(params).results
    else
      @title = 'Recent Reports'
      @reports = Report.published.by_updated_at.paginate(:page => params[:page], :per_page => Report::PER_PAGE)
    end
  end
end
