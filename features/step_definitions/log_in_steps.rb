When /^I log in as "(.*)\/(.*)"$/ do |email, password|
  visit path_to('the login page')
  fill_in "Username/Email", :with => email
  fill_in "Password", :with => password
  click_button "Log in"
end

Given /^I am signed in$/ do
  When %{I log in as "#{current_user.email}/#{current_user.password}"}
end

Given /^I am signed in as "([^"]*)"$/ do |name|
  user = current_user(:username => name)
  When %{I log in as "#{user.email}/#{user.password}"}
end