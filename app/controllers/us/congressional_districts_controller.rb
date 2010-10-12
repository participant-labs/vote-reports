class Us::CongressionalDistrictsController < ApplicationController
  def show
    @district = CongressionalDistrict.find_by_name(params[:id])

    @presidents = @district.presidents.in_office
    @representative = @district.representatives.in_office
    @senators = @district.senators.in_office
  end
end
