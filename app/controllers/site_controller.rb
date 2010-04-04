class SiteController < ApplicationController

  def index
    if params[:representing].present? && zip_code?(params[:representing])
      session[:zip_code] = params[:representing]
    end

    params[:subjects] ||= []
    params[:in_office] = true if params[:in_office].nil?

    if politicians_sought?
      @politicians = sought_politicians.all(:limit => 5)
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

    @topical_reports = @topical_reports.scoped(:limit => 3) if @topical_reports

    respond_to do |format|
      format.html {
        @recent_reports = Report.user_published.by_updated_at.all(:limit => 3)
        @featured_interest_group_reports = Report.interest_group_published.random.all(:limit => 3)
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
    elsif politicians_sought?
      Report.published
    end
  end
end
