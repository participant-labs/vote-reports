class InterestGroups::ScoresController < ApplicationController
  def show
    @interest_group = InterestGroup.find(params[:interest_group_id])
    @score = @interest_group.report.scores.find(params[:id])
    render :layout => false
  end
end
