class InterestGroups::ImagesController < ApplicationController
  filter_access_to :all

  def create
    @interest_group = InterestGroup.find(params[:interest_group_id])
    @interest_group.build_image(params[:image])
    if @interest_group.save
      flash[:notice] = "Successfully updated thumbnail."
    else
      flash[:error] = "Unable to update thumbnail."
    end
    redirect_to @interest_group
  end

  def edit
    @interest_group = InterestGroup.find(params[:interest_group_id])
    @image = @interest_group.thumbnail
  end

  def update
    @interest_group = InterestGroup.find(params[:interest_group_id])
    if @interest_group.image.update_attributes(params[:image])
      flash[:notice] = "Successfully updated thumbnail."
    else
      flash[:error] = "Unable to update thumbnail."
    end
    redirect_to @interest_group
  end
end
