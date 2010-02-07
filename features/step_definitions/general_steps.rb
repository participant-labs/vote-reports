Then /^I should see error messages$/ do
  Then %{I should see "There were problems with the following fields"}
end

Given /^the following (.+) records?:$/ do |type, table|
  table.hashes.each do |row|
    send "create_#{type.to_s.gsub(' ', '_').underscore}", row.symbolize_keys
  end
end

When /^I console$/ do
  console_for(binding)
end

When /^I debug$/ do
  require 'ruby-debug'
  debugger
  x = 1 + 1
end

Then /^I should( not|) see the button "(.*)"$/ do |should_not, button_text|
  selector = "[value='#{button_text.strip}'][type=submit]"
  if should_not.present?
    response.should_not have_selector(selector)
  else
    response.should have_selector(selector)
  end
end