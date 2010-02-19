class UserSessionsController < ApplicationController
  def new
    @return_to = params[:return_to]
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      if @user_session.new_registration?
        flash[:notice] = "Welcome! As a new user, please review your registration details before continuing.."
        redirect_to edit_user_path(current_user)
      elsif @user_session.registration_complete?
        flash[:notice] = "Logged in successfully"
        redirect_to (params[:return_to].present? ? params[:return_to] : current_user)
      else
        flash[:notice] = "Welcome back! Please complete required registration details before continuing.."
        redirect_to edit_user_path(current_user)
      end
    else
      render :action => 'new'
    end
  end

  def destroy
    @user_session = UserSession.find
    @user_session.destroy
    flash[:notice] = "You have been logged out"
    redirect_to root_url
  end
end
