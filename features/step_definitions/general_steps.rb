Then /^I should see error messages$/ do
  Then %{I should see "There were problems with the following fields"}
end

Given /^the following (.+) records?:$/ do |type, table|
  table.hashes.each do |row|
    send "create_#{type.to_s.gsub(' ', '_').underscore}", row.symbolize_keys
  end
end
