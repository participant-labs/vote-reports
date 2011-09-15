class Reports::SubjectsController < ApplicationController
  before_filter :load_report

  def index
    @subjects = @report.subjects.for_tag_cloud.all(
      select: "DISTINCT(subjects.*), SUM(report_subjects.count) AS count",
      limit: 30)
    render layout: false
  end

  private

  def load_report
    if params[:user_id]
      @user = User.find(params[:user_id])
      @report = @user.reports.find(params[:report_id])
    else
      @interest_group = InterestGroup.find(params[:interest_group_id], include: :report)
      @report = @interest_group.report
    end
  end
end
