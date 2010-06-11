class Causes::FollowsController < Reports::FollowsController
  private

  def load_report
    @report = Cause.find(params[:cause_id]).report
  end
end
