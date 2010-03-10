class SiteController < ApplicationController

  def index
    params[:subjects] ||= []
    if params[:from_where].present?
      @politicians = sought_politicians
      @topical_reports = topical_reports.with_scores_for(@politicians)
    elsif params[:subjects].present?
      @topical_reports = topical_reports
    end
    @subjects =
      if @topical_reports
        Subject.for_report(@topical_reports)
      else
        Subject.on_published_reports
      end.for_tag_cloud.all(:limit => 20)

    respond_to do |format|
      format.html {
        @recent_reports = Report.published.by_updated_at.paginate(:page => params[:page], :include => :user)
      }
      format.js {
        render :partial => 'site/instant_gratification'
      }
    end
  end

  def about
  end

private

  def topical_reports
    if params[:subjects].present?
      Report.published.with_subjects(params[:subjects])
    elsif params[:from_where].present?
      Report.published
    end
  end
end
