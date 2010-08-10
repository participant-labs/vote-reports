class GuidesController < ApplicationController
  layout 'minimal'

  def new
    if params[:from] == 'location' && !session[:congressional_district]
      session[:geo_location_declared] = true
      @geoloc = session[:declared_geo_location] = session[:geo_location]
      load_location_show_support(@geoloc)
      session[:congressional_district] = @federal.congressional_district
    end

    reports = params[:causes].present? ? Cause.find(params[:causes], :include => :report).map(&:report) : []
    @guide = Guide.new(:congressional_district => session[:congressional_district], :reports => reports)

    respond_to do |format|
      format.html {
        render :action => next_step
      }
      format.js {
        @js = true
        render :action => next_step, :layout => false
      }
    end
  end

  def create
    @guide = Guide.new(params[:guide].merge(:reports => Cause.find(params[:causes], :include => :report).map(&:report)))
    if @guide.save
      redirect_to guide_path(@guide)
    else
      render :action => next_step
    end
  end

  def show
    @guide = Guide.find(params[:id])
    @scores = @guide.scores.for_politicians(sought_politicians)
    @report = @guide.report

    respond_to do |format|
      format.html
      format.js {
        render :partial => 'reports/scores/table', :locals => {:report => @report, :scores => @scores}
      }
    end
  end

  private

  def next_step
    if @guide.reports.present? || params[:from] == 'causes'
      @causes = Cause.all
      @scores = @guide.immediate_scores
      :cause_scores
    elsif @guide.congressional_district.present? && params[:from] != 'set_location'
      @causes = Cause.all
      :causes
    elsif current_geo_location
      load_location_show_support(current_geo_location)
      :location
    else
      :set_location
    end
  end

end
