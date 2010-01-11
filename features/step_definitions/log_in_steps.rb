When /^I log in as "(.*)\/(.*)"$/ do |email, password|
  When %{I go to the login page}
  And %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  And %{I press "Log in"}
end

Given /^I am signed in$/ do
  When %{I log in as "#{current_user.email}/#{current_user.password}"}
end