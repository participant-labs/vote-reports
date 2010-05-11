class SiteController < ApplicationController

  def index
    @dont_show_geo_address = true
    params[:in_office] = true

    if params[:representing].present? && zip_code?(params[:representing])
      session[:zip_code] = params[:representing]
    end

    @recent_reports = Report.user_published.by_updated_at.all(:limit => 3)

    @reps = ['Your Local', 'local']
    @politicians = sought_politicians.scoped(:limit => 5)
    if @politicians.blank?
      @reps = ['These Example', 'example']
      @politicians = Politician.in_office(true).scoped(:limit => 5)
    end
    @scores =  @politicians.map {|politician| politician.report_scores.published.first(:order => 'random()') }.compact

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'scores/list', :locals => {:scores => @scores}
      }
    end
  end

  def about
  end
end
