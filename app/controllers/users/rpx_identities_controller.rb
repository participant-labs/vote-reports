class Users::RpxIdentitiesController < ApplicationController
  before_filter :is_current_user?

  def create
    @user = current_user
    if @user.save
      flash[:notice] = "Successfully added login to this account."
      redirect_to user_path(current_user)
    else
      flash[:error] = "Was unable to add login to this account: #{@user.errors.full_messages}"
      render 'users/edit'
    end
  end
end
