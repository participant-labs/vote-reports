class Users::ModeratorshipsController < ApplicationController
  filter_access_to :all

  def create
    @user = User.find(params[:user_id])
    if @user.moderatorship
      flash[:error] = "User is already an Moderator"
    elsif @user.create_moderatorship(:created_by => current_user)
      flash[:notice] = "Successfully promoted to Moderator"
    else
      flash[:error] = "Failed to grant Moderator status"
    end
    redirect_to edit_user_path(@user)
  end

  def destroy
    @user = User.find(params[:user_id])
    if !@user.moderatorship
      flash[:error] = "User is not a Moderator"
    else
      @user.moderatorship.destroy
      flash[:notice] = "Successfully revoked Moderator status"
    end
    redirect_to edit_user_path(@user)
  end
end
