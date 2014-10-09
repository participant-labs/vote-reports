Transform /^user "([^\"]*)"$/ do |username|
  User.find_by_username(username) || create(:user, username: username)
end

Given /^there is no user with "(.*)"$/ do |email|
  User.find_by_email(email).should == nil
end

Given /^an admin named "([^\"]*)"(?: promoted by (user "[^\"]*"))?$/ do |username, promotor|
  user = create(:user, username: username)
  user.create_adminship(created_by: promotor || create(:user))
end

Given /^a user named "([^\"]*)"$/ do |username|
  create(:user, username: username)
end
