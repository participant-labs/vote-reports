class UserSessionsController < ApplicationController
  filter_resource_access

  def new
    @user_session = UserSession.new

    respond_to do |format|
      format.html
      format.js {
        render layout: false
      }
    end
  end

  # def create
  #   @user_session = UserSession.new(params[:user_session])

  #   if @user_session.registration_incomplete?
  #     @current_user_session = @user_session
  #     @user = @user_session.attempted_record
  #     flash[:notice] = "Alright! Almost there, just a few details to correct before we can move on:"
  #     render 'users/new_from_rpx'
  #   elsif @user_session.save
  #     if @user_session.new_registration?
  #       flash[:notice] = redirect_to edit_user_path(@user_session.record, new_user: true),
  #         notice: "That does it! As a new user, please review your registration details before continuing.."
  #     else
  #       redirect_to (params[:return_to].present? \
  #         ? params[:return_to] \
  #         : user_path(@user_session.user)),
  #         notice: "Logged in successfully"
  #     end
  #   else
  #     flash[:error] = "Failed to login or register."
  #     render action: 'new'
  #   end
  # end

  def create
    if current_user
      current_user.authentications.create(:provider => auth_hash['provider'], :uid => auth_hash['uid']) #Add an auth to existing user
      redirect_to edit_user_path(:current),
        notice: "Successfully added #{auth_hash['provider']} authentication"
    elsif auth = Authentication.find_or_create_from_auth_hash(auth_hash)
      UserSession.create(auth.user, true)
      redirect_to root_url, notice: "Welcome back #{omniauth['provider']} user"
    else
      auth = Authentication.find_or_create_from_auth_hash(auth_hash)
      UserSession.create(auth.user, true)
      redirect_to root_url,
        notice: "Welcome #{auth_hash['provider']} user. Your account has been created."
    end
  end

  def failure
    flash.notice = "Sorry, You din't authorize"
    redirect_to root_url
  end

  def blank
    head :not_found
  end

  def destroy
    @authorization = current_user.authentications.find(params[:id])
    flash[:notice] = "Successfully deleted #{@authorization.provider} authentication."
    @authorization.destroy
    @user_session = current_user_session
    @user_session.destroy
    redirect_to root_path, notice: "You have been logged out"
  end

  private

  def auth_hash
    request.env['omniauth.auth']
  end
end
