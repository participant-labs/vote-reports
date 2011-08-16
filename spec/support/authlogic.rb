require "authlogic/test_case"

module Authlogic::Test
  def current_user(opts = {})
    if opts.empty?
      @current_user ||= create_user
    else
      logout
      @current_user = create_user(opts)
    end
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

RSpec.configure do |config|
  config.include(Authlogic::Test)
end
