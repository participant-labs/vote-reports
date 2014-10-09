Transform /^amendment "(.*)"$/ do |amendment_title|
  Amendment.with_title(amendment_title).first
end

Given /^an amendment named "([^"]*)" on (bill "[^"]*")$/ do |amendment_title, bill|
  create(:amendment, bill: bill, purpose: amendment_title, description: amendment_title)
end
