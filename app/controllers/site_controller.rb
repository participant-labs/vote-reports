class SiteController < ApplicationController

  def index
    if current_user
      redirect_to user_path(current_user)
    else
      render layout: 'footer_only'
    end
  end

  def show # about
  end

  def alive
    render text: 'Site is alive!'
  end

  if Rails.env.development?
    def fake_location
      session[:geo_location] = session[:declared_geo_location] = Geokit::GeoLoc.new(lat: 35, lng: -90, city: '- fake -', state: 'TN', zip: 88888, country_code: 'US')
      flash[:success] = 'Location set'
      redirect_to root_path
    end
  end
end
