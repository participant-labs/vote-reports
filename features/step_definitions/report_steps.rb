Transform /report "([^\"]*)"/ do |name|
  Report.find_by_name(name)
end

Given /^a report named "([^\"]*)"$/ do |name|
  create_report(:name => name)
end

Given /^I have a report named "([^\"]*)"$/ do |name|
  create_report(:name => name, :user => current_user)
end

Given /^a published report named "([^\"]*)"$/ do |name|
  bill = create_bill
  report = create_report(:name => name)
  create_bill_criterion(:bill => bill, :report => report)
end

Given /^I have a published report named "([^\"]*)"$/ do |name|
  bill = create_bill
  report = create_report(:name => name, :user => current_user)
  create_bill_criterion(:bill => bill, :report => report)
end

Given /^I have the following published reports?:$/ do |table|
  table.hashes.each do |row|
    create_report(row.symbolize_keys.merge(:user => current_user))
  end
end

Then /^I should see the following scores:$/ do |table|
  table.map_column!('politician') {|name| Politician.with_name(name).first }
  table.hashes.each do |hash|
    response.should contain("#{hash['politician'].full_name}: #{hash['score']}%")
  end
end
