class UserSession < Authlogic::Session::Base
  find_by_login_method :find_by_username_or_email
  generalize_credentials_error_messages true
  rpx_key RPX_API_KEY

private

  # map_rpx_data maps additional fields from the RPX response into the user object
  # override this in your session controller to change the field mapping
  # see https://rpxnow.com/docs#profile_data for the definition of available attributes
  #
  def map_rpx_data
    # map core profile data using authlogic indirect column names
    if attempted_record.send(klass.login_field).blank?
      attempted_record.send(:"#{klass.login_field}=", @rpx_data['profile']['preferredUsername'] )
    end
    if attempted_record.send(klass.email_field).blank?
      attempted_record.send(:"#{klass.email_field}=", @rpx_data['profile']['email'] ) 
    end
  end
end
