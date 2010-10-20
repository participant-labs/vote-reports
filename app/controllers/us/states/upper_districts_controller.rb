class Us::States::UpperDistrictsController < ApplicationController
  def show
    @state = UsState.find(params[:state_id].upcase)
    @district = @state.districts.state_upper.with_name(params[:id]).first

    @presidents = @state.presidents.in_office
    @senators = @state.senators.in_office
  end
end
