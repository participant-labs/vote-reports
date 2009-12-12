Then /^I should see error messages$/ do
  Then %{I should see "There were problems with the following fields"}
end

Then /^I should be signed in$/ do
  assert_not_nil request.session['user_credentials_id']
end

Then /^I should not be signed in$/ do
  assert_nil request.session['user_credentials_id']
end

Given /^the following (.+) records?:$/ do |type, table|
  table.hashes.each do |row|
    Factory.create(type.to_s.gsub(' ', '_').underscore.to_sym, row.symbolize_keys)
  end
end
