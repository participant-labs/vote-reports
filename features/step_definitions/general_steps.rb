Then /^I should see error messages$/ do
  Then %{I should see "There were problems with the following fields"}
end

Then /^I should be signed in$/ do
  assert_not_nil request.session['user_credentials_id']
end

Then /^I should not be signed in$/ do
  assert_nil request.session['user_credentials_id']
end