class Users::Reports::FollowsController < Reports::FollowsController
  private

  def load_report
    @report = User.find(params[:user_id]).reports.find(params[:report_id])
  end
end
