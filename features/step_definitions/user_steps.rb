Transform /user "(.*)"/ do |username|
  User.find_by_username(username)
end

Given /^there is no user with "(.*)"$/ do |email|
  User.find_by_email(email).should == nil
end
