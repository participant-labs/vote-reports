class InterestGroups::AgendasController < ApplicationController
  def show
    @interest_group = InterestGroup.find(params[:interest_group_id], :include => :reports)
    render :layout => false
  end
end
