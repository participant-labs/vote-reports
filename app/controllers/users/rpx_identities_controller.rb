class Users::RpxIdentitiesController < ApplicationController
  before_filter :is_current_user?

  def create
    @user = current_user
    if @user.save
      flash[:notice] = "Successfully added login to this account."
    else
      flash[:error] = "Unable to add login because it is already associated with another account"
    end
    redirect_to user_path(current_user)
  end

  def destroy
    @user = current_user
    @identifier = @user.rpx_identifiers.find(params[:id])
    @identifier.destroy
    flash[:notice] = "Successfully removed login."
    redirect_to edit_user_path(current_user)
  end
end
