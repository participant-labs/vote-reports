Given /^a bill named "([^\"]*)"$/ do |title|
  create_bill_title :title => title
end

Given /^(\d+) recent bills$/ do |count|
  count.to_i.times do
    create_bill
  end
end
