class Users::ModeratorshipsController < ApplicationController
  filter_access_to :all
  before_filter :find_user

  def create
    if @user.moderatorship
      flash[:error] = "User is already an Moderator"
    elsif @user.create_moderatorship(created_by: current_user)
      flash[:notice] = "Successfully promoted to Moderator"
    else
      flash[:error] = "Failed to grant Moderator status"
    end
    redirect_to edit_user_path(@user)
  end

  def destroy
    if !@user.moderatorship
      flash[:error] = "User is not a Moderator"
    else
      @user.moderatorship.destroy
      flash[:notice] = "Successfully revoked Moderator status"
    end
    redirect_to edit_user_path(@user)
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end
end
