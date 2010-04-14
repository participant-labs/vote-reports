class GuidesController < ApplicationController
  def show
    @dont_show_geo_address = true

    if params[:representing].present? && zip_code?(params[:representing])
      session[:zip_code] = params[:representing]
    end

    params[:subjects] ||= []
    params[:in_office] = true if params[:in_office].nil?

    @politicians = sought_politicians.all(:limit => 5)
    @topical_reports = Report.published.with_scores_for(@politicians)
    if params[:subjects].present?
      @topical_reports = @topical_reports.with_subjects(params[:subjects])
    end

    @subjects =
      if @topical_reports
        Subject.for_report(@topical_reports)
      else
        Subject.on_published_reports
      end.for_tag_cloud.all(:limit => 20)

    @topical_reports = @topical_reports.scoped(:limit => 10) if @topical_reports

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'site/guide', :locals => {:target_path => 'guide_path'}
      }
    end
  end
end
