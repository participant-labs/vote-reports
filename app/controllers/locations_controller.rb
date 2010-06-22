class LocationsController < ApplicationController
  def new
    respond_to do |format|
      format.html
      format.js {
        render :layout => false
      }
    end
  end

  def create
    @geoloc = Geokit::Geocoders::MultiGeocoder.geocode(params[:location])
    action =
      if !@geoloc.success?
        flash.now[:error] = %Q{Sorry, we were unable to understand this location. Could you clarify it?}
        'new'
      elsif !@geoloc.is_us?
        flash.now[:error] = %Q{Sorry, we currently only handle representatives for the United States of America.}
        'new'
      else
        if !%w[street address].include?(@geoloc.precision)
          flash.now[:notice] = %Q{For more accurate results, an address or intersection is best, but here's our best guess from what you've said.}
        else
          flash.now[:success] = "Successfully set location"
        end
        session[:location] = params[:location]
        session[:geo_location] = @geoloc

        load_districts

        'show'
      end
    respond_to do |format|
      format.html {
        render :action => action
      }
      format.js {
        @js = true
        render :action => action, :layout => false
      }
    end
  end

  def show
    if params[:location].present?
      create
      return
    end
    unless @geoloc = session[:geo_location]
      render :action => :new
      return
    end

    load_districts

    respond_to do |format|
      format.html
      format.js {
        @js = true
        render :layout => false
      }
    end
  end

  def destroy
    flash[:success] = "Successfully cleared location"
    session[:location] = nil
    session[:geo_location] = nil
    redirect_to params[:return_to] || root_path
  end

  private

  def load_districts
    @districts = District.lookup(@geoloc).index_by(&:full_name).values
    @federal = @districts.detect {|d| d.level.to_s == 'federal' }
    @bounds = @federal.polygon.envelope
    @politicians = Politician.for_districts(@districts).in_office
  end
end
