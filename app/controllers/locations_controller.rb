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
    @geoloc =
      if params[:location].present?
        Geokit::Geocoders::MultiGeocoder.geocode(params[:location])
      elsif params[:autoloc]
        Geokit::LatLng.new(*params[:autoloc].values_at(:lat, :lng)).reverse_geocode
      end
    session[:geo_location_declared] = @geoloc.try(:success?)

    action =
      if !session[:geo_location_declared]
        message = {:error => %Q{Sorry, we were unable to understand this location. Could you clarify it?}}
        'new'
      elsif !@geoloc.is_us?
        message = {:error => %Q{Sorry, we currently only handle representatives for the United States of America.}}
        'new'
      else
        message = {:success => "Successfully set location"}

        load_location_show_support(@geoloc)

        session[:declared_location] = params[:location]
        session[:congressional_district] = @federal.congressional_district
        session[:declared_geo_location] = @geoloc

        'show'
      end

    respond_to do |format|
      format.html {
        flash[message.first.first] = message.first.last
        if params[:return_to]
          redirect_to params[:return_to]
        else
          render :action => action
        end
      }
      format.js {
        @js = true
        flash.now[message.first.first] = message.first.last
        render :action => action, :layout => false
      }
    end
  end

  def show
    if params[:location].present? || params[:autoloc].present?
      create
      return
    end
    unless @geoloc = current_geo_location
      respond_to do |format|
        format.html {
          render :action => :new
        }
        format.js {
          @js = true
          render :action => :new, :layout => false
        }
      end
      return
    end

    load_location_show_support(@geoloc)

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
    session.clear
    redirect_to params[:return_to] || root_path
  end

end
