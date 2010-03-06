class SiteController < ApplicationController

  def index
    @recent_reports = Report.published.by_updated_at.paginate(:page => params[:page], :include => :user)
    @topical_reports = Report.published
    if params[:tag].present?
      @topical_reports = @topical_reports.with_subject(params[:tag])
    end
    if params[:from_where].present?
      @politicians = sought_politicians
      @topical_reports = @topical_reports.with_scores_for(@politicians)
    end
    @subjects = Subject.for_report(@topical_reports).for_tag_cloud.all(:limit => 20)
  end

  def about
  end

end
