Given /^a report named "([^\"]*)"$/ do |name|
  Report.make(:name => name)
end

Given /^a report by me named "([^\"]*)"$/ do |name|
  Report.make(:name => name, :user => @current_user)
end

Given /^a published report named "([^\"]*)"$/ do |name|
  bill = Bill.make
  report = Report.make(:name => name)
  BillCriterion.make(:bill => bill, :report => report)
end

Given /^a published report by me named "([^\"]*)"$/ do |name|
  bill = Bill.make
  report = Report.make(:name => name, :user => @current_user)
  BillCriterion.make(:bill => bill, :report => report)
end

Given /^the following published reports by me:$/ do |table|
  table.hashes.each do |row|
    Report.make(row.symbolize_keys.merge(:user => @current_user))
  end
end
