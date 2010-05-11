class SiteController < ApplicationController

  def index
    @dont_show_geo_address = true
    params[:in_office] = true

    if params[:representing].present? && zip_code?(params[:representing])
      session[:zip_code] = params[:representing]
    end

    @recent_reports = Report.user_published.by_updated_at.all(:limit => 3)
    @featured_interest_group_reports = Report.interest_group_published.random.all(:limit => 3)
    reports = @recent_reports + @featured_interest_group_reports

    @politicians = sought_politicians.scoped(:limit => 5)
    @scores =  @politicians.map {|politician| politician.report_scores.published.first(:order => 'random()', :conditions => ['reports.id NOT IN(?)', reports]) }.compact
    if @scores.empty?
      @politicians = Politician.in_office(true).scoped(:limit => 5)
      @scores =  @politicians.map {|politician| politician.report_scores.published.first(:order => 'random()', :conditions => ['reports.id NOT IN(?)', reports]) }.compact
    end

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
