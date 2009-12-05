class ReportsController < ApplicationController
  before_filter :login_required, :except => [:index]

  def new
    redirect_to new_user_report_path(current_user)
  end

  def index
    @recent_reports = Report.recent.published
  end
end
