When /^I log in as "(.*)"$/ do |credentials|
  visit login_path
  And %Q{I enter my credentials "#{credentials}"}
end

When /^I enter my credentials "(.*)\/(.*)"/ do |email, password|
  fill_in "Username/Email", with: email
  fill_in "Password", with: password
  click_button "Log in"
end

Given /^I am signed in( as an Admin)?$/ do |admin|
  When %{I log in as "#{current_user.email}/#{current_user.password}"}
  current_user.create_adminship(created_by: current_user) if admin.present?
end

Given /^I am signed in as "([^"]*)"$/ do |name|
  user = current_user(username: name)
  When %{I log in as "#{user.email}/#{user.password}"}
end