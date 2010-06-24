class GuidesController < ApplicationController
  def new
    if params[:from] == 'location' && !session[:congressional_district]
      session[:geo_location_declared] = true
      @geoloc = session[:declared_geo_location] = session[:geo_location]
      load_location_show_support
      session[:location] = geo_description(@geoloc) + " (#{@federal.display_name})"
      session[:congressional_district] = @federal.congressional_district
    end

    @guide = Guide.new(:district_id => session[:congressional_district])

    respond_to do |format|
      format.html {
        render :action => next_step
      }
      format.js {
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
    if @guide.district.present?
      @causes = Cause.all
      :causes
    else
      load_location_show_support
      :location
    end
  end

end
