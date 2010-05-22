class UserSession < Authlogic::Session::Base
  find_by_login_method :find_by_username_or_email
  generalize_credentials_error_messages true
  rpx_key RPX_API_KEY

private

  def new_rpx_user(params)
    User.new(params[:user])
  end

  def map_rpx_data_each_login
    save_rpx_data
  end

  def map_added_rpx_data
    save_rpx_data
  end

  def save_rpx_data
    RpxIdentity.create(:user_id => attempted_record.id, :profile => @rpx_data)
  end
end
