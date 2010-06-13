class Us::DistrictsController < ApplicationController
  def show
    @district = District.find_by_name(params[:id])

    respond_to do |format|
      format.html {
        @representative = @district.representatives.in_office
        @senators = @district.senators.in_office
      }
      format.js {
        render :partial => 'us/districts/maps/map', :locals => {:district => @district}
      }
    end
  end
end
