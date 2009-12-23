require "authlogic/test_case"

def current_user
  @current_user ||= Factory(:user)
end
 
def login(user = nil)
  UserSession.create(user || current_user)
end
