Given /^a report named "([^\"]*)"$/ do |name|
  Factory.create(:report, :name => name)
end

Given /^a report by me named "([^\"]*)"$/ do |name|
  Factory.create(:report, :name => name, :user => @current_user)
end

Given /^a published report named "([^\"]*)"$/ do |name|
  bill = Factory.create(:bill)
  report = Factory.create(:report, :name => name)
  Factory.create(:bill_criterion, :bill => bill, :report => report)
end

Given /^a published report by me named "([^\"]*)"$/ do |name|
  bill = Factory.create(:bill)
  report = Factory.create(:report, :name => name, :user => @current_user)
  Factory.create(:bill_criterion, :bill => bill, :report => report)
end

Given /^the following published reports by me:$/ do |table|
  table.hashes.each do |row|
    Factory.create(:report, row.symbolize_keys.merge(:user => @current_user))
  end
end
