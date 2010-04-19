class Users::Reports::ThumbnailsController < ApplicationController
  filter_access_to :all

  def edit
    @report = current_user.reports.find(params[:report_id], :scope => current_user)
  end
end
