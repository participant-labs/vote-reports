class Users::RpxIdentitiesController < ApplicationController
  filter_access_to :all
  before_filter :find_user

  def create
    if @user.save
      flash[:notice] = "Successfully added login to this account."
    else
      flash[:error] = "Unable to add login because it is already associated with another account"
    end
    redirect_to user_path(@user)
  end

  def destroy
    @identifier = @user.rpx_identifiers.find(params[:id])
    @identifier.destroy
    flash[:notice] = "Successfully removed login."
    redirect_to edit_user_path(@user)
  end

  private

  def find_user
    @user = User.friendly.find(params[:user_id])
  end
end
