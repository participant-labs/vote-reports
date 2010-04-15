class Us::States::MapsController < ApplicationController
  def show
    @state = UsState.find(params[:us_state_id])
    render :layout => false
  end
end
