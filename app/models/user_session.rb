class UserSession < Authlogic::Session::Base
  find_by_login_method :find_by_username_or_email
  generalize_credentials_error_messages true
  rpx_key RPX_API_KEY

private
  def map_rpx_data_each_login
    save_rpx_data
    if attempted_record.email.blank? || attempted_record.email.ends_with?('+facebook@votereports.org')
      email = attempted_record.email
      attempted_record.send("#{klass.email_field}=", @rpx_data['profile']['email'])
      unless attempted_record.valid?
        attempted_record.send("#{klass.email_field}=", email)
      end
    end
  end

  def new_rpx_user(params)
    User.new(params[:user])
  end

  def save_rpx_data
    RpxIdentity.create(user_id: attempted_record.id, profile: @rpx_data)
  end
end
