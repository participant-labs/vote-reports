class Users::Reports::ThumbnailsController < ApplicationController
  filter_access_to :all
  before_filter :find_user_and_report

  def create
    @report.build_image(params[:image])
    if @report.save && @report.image.save
      flash[:notice] = "Successfully updated thumbnail."
    else
      flash[:error] = "Unable to update thumbnail."
    end
    redirect_to [@user, @report]
  end

  def edit
    @image = @report.thumbnail
    render layout: false
  end

  def update
    if @report.image.update_attributes(params[:image])
      flash[:notice] = "Successfully updated thumbnail."
    else
      flash[:error] = "Unable to update thumbnail."
    end
    redirect_to [@user, @report]
  end

  private

  def find_user_and_report
    @user = User.find(params[:user_id])
    @report = @user.reports.find(params[:report_id])
  end
end
