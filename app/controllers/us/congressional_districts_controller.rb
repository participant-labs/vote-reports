class Us::CongressionalDistrictsController < ApplicationController
  def show
    @district = CongressionalDistrict.find_by_name(params[:id])

    respond_to do |format|
      format.html {
        @representative = @district.representatives.in_office
        @senators = @district.senators.in_office
      }
      format.js {
        @js = true
        render :partial => 'districts/map', :locals => {:district => @district}
      }
    end
  end
end
