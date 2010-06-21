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
    geoloc = Geokit::Geocoders::MultiGeocoder.geocode(params[:location])
    if !geoloc.success?
      flash.now[:error] = %Q{Sorry, we were unable to understand this location. Could you clarify it?}
      render :action => 'new'
    elsif !geoloc.is_us?
      flash.now[:error] = %Q{Sorry, we currently only handle representatives for the United States of America.}
      render :action => 'new'
    elsif !%w[street address].include?(geoloc.precision)
      flash.now[:error] = %Q{In order to pinpoint both state and federal officals, we need an address or intersection.}
      render :action => 'new'
    else
      flash.now[:success] = "Successfully set location"
      @districts = District.lookup(geoloc)
      @bounds = @districts.federal.first.polygon.envelope

      render :action => 'show'
    end
  end

  def destroy
    flash[:success] = "Successfully cleared location"
    session[:zip_code] = nil
    redirect_to params[:return_to] || root_path
  end
end
