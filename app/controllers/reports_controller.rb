class ReportsController < ApplicationController
  before_filter :login_required, :except => [:index]

  def new
    redirect_to new_user_report_path(current_user)
  end

  def index
    params[:subjects] ||= []
    if (@q = params[:q]).present?
      @title = 'Matching Reports'
      @reports = Report.paginated_search(params).results
    else
      @title = 'Recent Reports'
      @reports = topical_reports.by_updated_at.paginate(:page => params[:page])
    end

    @subjects = Subject.for_report(topical_reports).for_tag_cloud.all(:limit => 20)

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'reports/list', :locals => {:reports => @reports}
      }
    end
  end

  private

  def topical_reports
    if params[:subjects].present?
      Report.published_by(params).with_subjects(params[:subjects])
    else
      Report.published_by(params)
    end
  end
end
