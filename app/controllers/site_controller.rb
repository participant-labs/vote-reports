class SiteController < ApplicationController

  def index
    @recent_reports = Report.published.by_updated_at.paginate(:page => params[:page], :include => :user)
    @subjects = Subject.for_report(Report.published).for_tag_cloud.all(:limit => 20)
    if params[:tag].present? && params[:from_where].present?
      @scores = nil
    elsif params[:tag].present?
      @topical_reports = Report.with_subject(params[:tag]).all(:limit => 5)
    elsif params[:from_where].present?
      @politicians = Politician.from(params[:from_where]).all(:limit => 5)
    end
  end

  def about
  end

end
