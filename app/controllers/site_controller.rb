class SiteController < ApplicationController

  def index
    if current_user
      dashboard
    else
      render :layout => 'footer_only'
    end
  end

  def alive
    render :text => 'Site is alive!'
  end

  def about
  end

  def dashboard
    @user = current_user
    @reports = current_user.reports
    render :template => 'users/show'
  end

  if Rails.env.development?
    def fake_location
      session[:geo_location] = session[:declared_geo_location] = Geokit::GeoLoc.new(:lat => 35, :lng => -90, :city => '- fake -', :state => 'TN', :zip => 88888, :country_code => 'US')
      flash[:success] = 'Location set'
      redirect_to root_path
    end
  end
end
