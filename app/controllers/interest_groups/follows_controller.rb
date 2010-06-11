class InterestGroups::FollowsController < Reports::FollowsController
  private

  def load_report
    @report = InterestGroup.find(params[:interest_group_id]).report
  end
end
