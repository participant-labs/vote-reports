class Users::RpxIdentitiesController < ApplicationController
  def create
    @user = current_user
    if @user.save
      flash[:notice] = "Successfully added login to this account."
    else
      flash[:error] = "Was unable to add login to this account: #{@user.errors.full_messages}"
    end
    redirect_to user_path(current_user)
  end
end