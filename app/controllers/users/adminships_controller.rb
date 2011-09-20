class Users::AdminshipsController < ApplicationController
  filter_access_to :all
  before_filter :find_user

  def create
    if @user.adminship
      flash[:error] = "User is already an Admin"
    elsif @user.create_adminship(created_by: current_user)
      flash[:notice] = "Successfully promoted to Admin"
    else
      flash[:error] = "Failed to grant Admin status"
    end
    redirect_to edit_user_path(@user)
  end

  def destroy
    if !@user.adminship
      flash[:error] = "User is not an Admin"
    else
      @user.adminship.destroy
      flash[:notice] = "Successfully revoked Admin status"
    end
    redirect_to edit_user_path(@user)
  end

  private

  def find_user
    @user = User.find(params[:user_id])
  end
end
