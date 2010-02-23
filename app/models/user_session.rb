class UserSession < Authlogic::Session::Base
  find_by_login_method :find_by_username_or_email
  generalize_credentials_error_messages true
  rpx_key RPX_API_KEY

private

  def new_rpx_user(params)
    User.new(params[:user])
  end
end
