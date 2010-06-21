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
    if !@geoloc.success?
      flash.now[:error] = %Q{Sorry, we were unable to understand this location. Could you clarify it?}
      render :action => 'new'
    elsif !@geoloc.is_us?
      flash.now[:error] = %Q{Sorry, we currently only handle representatives for the United States of America.}
      render :action => 'new'
    else
      if !%w[street address].include?(@geoloc.precision)
        flash.now[:notice] = %Q{For more accurate results, an address or intersection is best, but here's our best guess from what you've said.}
      else
        flash.now[:success] = "Successfully set location"
      end
      @districts = District.lookup(@geoloc)
      @federal = @districts.federal.first
      @bounds = @federal.polygon.envelope
      @politicians = Politician.for_districts(@districts).in_office

      render :action => 'show'
    end
  end

  def destroy
    flash[:success] = "Successfully cleared location"
    session[:zip_code] = nil
    redirect_to params[:return_to] || root_path
  end
end
