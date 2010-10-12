class Us::StatesController < ApplicationController
  def show
    @state = UsState.find(params[:id].upcase)

    @presidents = @state.presidents.in_office
    @senators = @state.senators.in_office
    @representatives = @state.representatives_in_office.sort_by {|r| r.current_office.congressional_district.district }
  end
end
