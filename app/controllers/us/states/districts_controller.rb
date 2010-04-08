class Us::States::DistrictsController < ApplicationController
  def show
    @district = District.find_by_name(params[:id])
    @representative = @district.representatives.in_office
    @senators = @district.senators.in_office
  end
end
