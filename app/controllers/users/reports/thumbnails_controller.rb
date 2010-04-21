class Users::Reports::ThumbnailsController < ApplicationController
  filter_access_to :all

  def edit
    @user = User.find(params[:user_id])
    @report = @user.reports.find(params[:report_id], :scope => @user)
    @image = @report.thumbnail
  end

  def update
    @user = User.find(params[:user_id])
    @report = @user.reports.find(params[:report_id], :scope => @user)
    if @report.thumbnail.update_attributes(params[:image])
      flash[:notice] = "Successfully updated thumbnail."
    else
      flash[:error] = "Unable to update thumbnail."
    end
    redirect_to [@user, @report]
  end
end
