class Us::CongressionalDistricts::MapsController < ApplicationController
  def show
    @district = CongressionalDistrict.find_by_name(params[:congressional_district_id])
    @js = true
    render :layout => (params[:layout] || false)
  end
end
