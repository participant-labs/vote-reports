When /^I log in as "(.*)\/(.*)"$/ do |email, password|
  When %{I go to the log in page}
  And %{I fill in "Email" with "#{email}"}
  And %{I fill in "Password" with "#{password}"}
  And %{I press "Log in"}
end