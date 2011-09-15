class InterestGroups::CausesController < ApplicationController
  def index
    @interest_group = InterestGroup.find(params[:interest_group_id])
    @causes = @interest_group.causes.page(params[:page])
    render layout: false
  end
end
