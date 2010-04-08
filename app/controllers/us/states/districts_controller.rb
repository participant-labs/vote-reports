class Us::States::DistrictsController < ApplicationController
  def show
    @district = District.find_by_name(params[:id])
    @title = @district.full_title_name
    @representative = @district.representatives.in_office
    @senators = @district.senators.in_office
  end
end
