Given /^there is no user with "(.*)"$/ do |email|
  assert_nil User.find_by_email(email)
end