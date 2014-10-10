class InterestGroups::AgendasController < ApplicationController
  def show
    @interest_group = InterestGroup.find(params[:interest_group_id], include: :reports)
    @report = @interest_group
    render layout: false
  end
end
