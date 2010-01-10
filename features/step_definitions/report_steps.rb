Given /^a report named "([^\"]*)"$/ do |name|
  create_report(:name => name)
end

Given /^I have a report named "([^\"]*)"$/ do |name|
  create_report(:name => name, :user => @current_user)
end

Given /^a published report named "([^\"]*)"$/ do |name|
  bill = create_bill
  report = create_report(:name => name)
  create_bill_criterion(:bill => bill, :report => report)
end

Given /^I have a published report named "([^\"]*)"$/ do |name|
  bill = create_bill
  report = create_report(:name => name, :user => @current_user)
  create_bill_criterion(:bill => bill, :report => report)
end

Given /^the following published reports by me:$/ do |table|
  table.hashes.each do |row|
    create_report(row.symbolize_keys.merge(:user => @current_user))
  end
end
