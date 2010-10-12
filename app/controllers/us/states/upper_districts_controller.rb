class Us::States::UpperDistrictsController < ApplicationController
  def show
    @state = UsState.find(params[:state_id])
    @district = @state.districts.find_by_name_and_level(params[:id], 'state_upper')

    @presidents = @state.presidents.in_office
    @senators = @state.senators.in_office
  end
end
