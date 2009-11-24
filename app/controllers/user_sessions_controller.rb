class UserSessionsController < ApplicationController
  def new
    @return_to = params[:return_to]
    @user_session = UserSession.new
  end

  def create
    @user_session = UserSession.new(params[:user_session])
    if @user_session.save
      flash[:notice] = "Logged in successfully"
      redirect_to (params[:return_to].present? ? params[:return_to] : current_user)
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
