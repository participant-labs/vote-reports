class Causes::ImagesController < ApplicationController
  filter_access_to :all
  before_filter :find_cause
  layout nil

  def create
    @cause.build_image(params[:image])
    if @cause.report.save && @cause.image.save
      flash[:notice] = "Successfully updated thumbnail."
    else
      flash[:error] = "Unable to update thumbnail."
    end
    redirect_to @cause
  end

  def edit
    @image = @cause.thumbnail
    render layout: false
  end

  def update
    if @cause.image.update_attributes(params[:image])
      flash[:notice] = "Successfully updated thumbnail."
    else
      flash[:error] = "Unable to update thumbnail."
    end
    redirect_to @cause
  end

  private

  def find_cause
    @cause = Cause.find(params[:cause_id])
  end
end
