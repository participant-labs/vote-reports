Then /^I should see error messages$/ do
  step %{I should see "There were problems with the following fields"}
end

Given /^the following (.+) records?:$/ do |type, table|
  table.hashes.each do |row|
    create :"#{type.to_s.tr(' ', '_').underscore}", row.symbolize_keys
  end
  Politician.update_current_office_status!(quiet: true) if type.include?(' term')
end

Given /^this is pending$/ do
  pending
end

When /^I wait (\d+) seconds$/ do |seconds|
  print seconds
  sleep seconds.to_i
end

When /^I wait for delayed job to finish$/ do
  results = Delayed::Worker.new(quiet: true).work_off(5)
  if results.last != 0
    raise "Error processing delayed job - #{results.last} failures"
  end
end

When /^I console$/ do
  console_for(binding)
end

When /^I debug$/ do
  require 'byebug'
  byebug
  x = 1 + 1
end

Then /^I should( not|) see the button "(.*)"$/ do |should_not, button_text|
  selector = "[value='#{button_text.strip}'][type=submit]"
  if should_not.present?
    expect(page).to_not have_css(selector)
  else
    expect(page).to have_css(selector)
  end
end

Then /^I should( not|) see the image "(.*)"$/ do |should_not, file_name|
  selector = "img[src*='/#{file_name.strip}?']"
  if should_not.present?
    expect(page).to_not have_css(selector)
  else
    expect(page).to have_css(selector)
  end
end

Then /^I should( not|) see the title "(.*)"$/ do |should_not, title|
  selector = "*[title='#{title}']"
  if should_not.present?
    expect(page).to_not have_css(selector)
  else
    expect(page).to have_css(selector)
  end
end
