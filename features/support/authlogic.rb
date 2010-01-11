require Rails.root.join('spec/support/authlogic')

Before do
  activate_authlogic
end

World(Authlogic::Test)
