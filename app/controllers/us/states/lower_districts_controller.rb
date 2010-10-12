class Us::States::LowerDistrictsController < ApplicationController
  def show
    @state = UsState.find(params[:state_id].upcase)
    @district = @state.districts.find_by_name_and_level(params[:id], 'state_lower')

    @presidents = @state.presidents.in_office
    @senators = @state.senators.in_office
  end
end
