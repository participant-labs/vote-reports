class SiteController < ApplicationController

  def index
    @recent_reports = Report.published.by_updated_at.paginate(:page => params[:page], :include => :user)
    if params[:from_where].present?
      @politicians = sought_politicians
      @topical_reports = topical_reports.with_scores_for(@politicians)
    elsif params[:tag].present?
      @topical_reports = topical_reports
    end
    @subjects =
      if @topical_reports
        Subject.for_report(@topical_reports)
      else
        Subject.on_published_reports
      end.for_tag_cloud.all(:limit => 20)
  end

  def about
  end

private

  def topical_reports
    if params[:tag].present?
      Report.published.with_subject(params[:tag])
    elsif params[:from_where].present?
      Report.published
    end
  end
end
