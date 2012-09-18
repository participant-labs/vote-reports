require Rails.root.join('spec/support/authlogic')

# Override logout to not mess with the cookies, which isn't legit under capybara
module Authlogic::Test
  def logout
    @current_user = nil
  end
end

Before do
  activate_authlogic
end

World(Authlogic::Test)
