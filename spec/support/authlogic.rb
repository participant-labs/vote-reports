require "authlogic/test_case"

def current_user
  @current_user ||= create_user
end
 
def login(user = nil)
  UserSession.create(user || current_user)
end
