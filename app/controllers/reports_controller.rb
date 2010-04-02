class ReportsController < ApplicationController
  before_filter :login_required, :except => [:index]

  def new
    redirect_to new_user_report_path(current_user)
  end

  def index
    if (@q = params[:q]).present?
      @title = 'Matching Reports'
      @reports = Report.paginated_search(params).results
    else
      @title = 'Recent Reports'
      @reports = Report.published_by(params).by_updated_at.paginate(:page => params[:page])
    end

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'reports/list', :locals => {:reports => @reports}
      }
    end
  end
end
