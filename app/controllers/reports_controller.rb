class ReportsController < ApplicationController
  filter_access_to :all

  def new
    redirect_to new_user_report_path(current_user)
  end

  def index
    params[:subjects] ||= []
    if params[:term].present?
      @title = 'Matching Reports'
      @reports = Report.paginated_search(params)
    elsif params[:without_causes].present?
      @title = 'Reports without Causes'
      @reports = Report.non_cause.published.without_associated_cause.by_name.for_display.page(params[:page])
    elsif params[:from_members]
      @title = 'Member Reports'
      @reports = topical_reports.user_published.by_name.page(params[:page])
    else
      @title = 'Reports'
      @reports = topical_reports.by_name.page(params[:page])
    end

    @subjects = Subject.for_report(topical_reports).for_tag_cloud.all(:limit => 20)

    respond_to do |format|
      format.html
      format.js {
        render :layout => false
      }
      format.json {
        render :json => @reports
      }
    end
  end

  private

  def topical_reports
    Report.published.with_subjects(params[:subjects]).for_display
  end
end
