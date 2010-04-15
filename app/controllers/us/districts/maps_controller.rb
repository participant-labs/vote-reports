class Us::Districts::MapsController < ApplicationController
  def show
    @district = District.find_by_name(params[:district_id])
    render :layout => 'minimal'
  end
end
