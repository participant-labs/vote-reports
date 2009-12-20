Given /^a bill named "([^\"]*)"$/ do |title|
  Bill.make :title => title
end

Given /^(\d+) recent bills$/ do |count|
  count.to_i.times do
    Bill.make
  end
end
