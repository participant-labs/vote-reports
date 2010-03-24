Given /an interest group named "(.*)"/ do |name|
  create_interest_group(:name => name)
end