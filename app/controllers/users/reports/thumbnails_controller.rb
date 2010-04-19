class Users::Reports::ThumbnailsController < ApplicationController
  before_filter :is_report_owner
  filter_resource_access

  def edit
    @report = current_user.reports.find(params[:report_id], :scope => current_user)
  end
end
