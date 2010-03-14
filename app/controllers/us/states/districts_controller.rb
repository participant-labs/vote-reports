class Us::States::DistrictsController < ApplicationController
  def show
    @state = UsState.find(params[:state_id].upcase)
    @district = @state.districts.find_by_district(params[:id])
    @title = "#{@state.full_name} District #{@district.district}"
    @representative = @district.representatives.in_office
    @senators = @district.senators.in_office
  end
end
