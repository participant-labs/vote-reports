class InterestGroups::ClaimsController < ApplicationController
  layout nil

  def new
    @interest_group = InterestGroup.friendly.find(params[:interest_group_id])
  end
end
