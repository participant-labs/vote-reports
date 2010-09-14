class InterestGroups::ClaimsController < ApplicationController
  layout nil

  def new
    @interest_group = InterestGroup.find(params[:interest_group_id])
  end
end
