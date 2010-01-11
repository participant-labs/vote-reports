require "authlogic/test_case"

module Authlogic::Test
  def current_user
    @current_user ||= create_user
  end
 
  def login(user = nil)
    user ||= current_user
    UserSession.create(user)
    @current_user = user
  end

  def logout
    User.forget_all
    @current_user = nil
  end
end