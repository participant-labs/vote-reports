class SiteController < ApplicationController

  def index
    @recent_reports = Report.published.by_updated_at.paginate(:page => params[:page], :include => :user)
    @subjects = Subject.for_report(Report.published).for_tag_cloud.all(:limit => 20)
  end

  def about
  end

end
