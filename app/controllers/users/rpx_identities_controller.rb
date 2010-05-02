class Users::RpxIdentitiesController < ApplicationController
  filter_access_to :all

  def create
    @user = User.find(params[:user_id])
    if @user.save
      flash[:notice] = "Successfully added login to this account."
    else
      flash[:error] = "Unable to add login because it is already associated with another account"
    end
    redirect_to user_path(@user)
  end

  def destroy
    @user = User.find(params[:user_id])
    @identifier = @user.rpx_identifiers.find(params[:id])
    @identifier.destroy
    flash[:notice] = "Successfully removed login."
    redirect_to edit_user_path(@user)
  end
end
