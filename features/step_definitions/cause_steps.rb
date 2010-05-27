Given /^a cause named "([^"]*)"$/ do |cause_name|
  create_cause(:name => cause_name)
end