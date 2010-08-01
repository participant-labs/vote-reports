class InterestGroups::ImagesController < ApplicationController
  filter_access_to :all
  before_filter :find_interest_group

  def create
    @interest_group.build_image(params[:image])
    if @interest_group.save && @interest_group.image.save
      flash[:notice] = "Successfully updated thumbnail."
    else
      flash[:error] = "Unable to update thumbnail."
    end
    redirect_to @interest_group
  end

  def edit
    @image = @interest_group.thumbnail
    render :layout => false
  end

  def update
    if @interest_group.image.update_attributes(params[:image])
      flash[:notice] = "Successfully updated thumbnail."
    else
      flash[:error] = "Unable to update thumbnail."
    end
    redirect_to @interest_group
  end

  private

  def find_interest_group
    @interest_group = InterestGroup.find(params[:interest_group_id])
  end
end
