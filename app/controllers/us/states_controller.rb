class Us::StatesController < ApplicationController
  def show
    @state = UsState.find(params[:id].upcase)
    @senators = @state.senators.in_office
    @representatives = @state.representatives_in_office.by_district
  end
end
