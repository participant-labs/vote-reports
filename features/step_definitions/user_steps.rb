Given /^there is no user with "(.*)"$/ do |email|
  User.find_by_email(email).should == nil
end