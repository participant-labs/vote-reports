Transform /^cause "(.*)"$/ do |cause_name|
  Cause.find_by_name(cause_name)
end

Given /^a cause named "([^"]*)"$/ do |cause_name|
  create_cause(:name => cause_name)
end

Given /^(cause "[^"]*") includes (report "[^"]*")$/ do |cause, report|
  cause.reports << report
end
