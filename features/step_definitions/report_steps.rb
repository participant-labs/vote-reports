Transform /^report "([^\"]*)"$/ do |name|
  Report.find_by_name(name)
end

Given /^(I have |)an? (.*?) ?report named "([^\"]*)"$/ do |mine, type, name|
  params = mine.present? ? {:user => current_user} : {}
  creator = type.present? ? :"create_#{type}_report" : :create_report
  send(creator, params.merge(:name => name))
end

Given /^(\d+) published reports$/ do |count|
  count.to_i.times do
    create_published_report
  end
end

Given /^I have the following (.*) reports?:$/ do |type, table|
  table.hashes.each do |row|
    send(:"create_#{type}_report", row.symbolize_keys.merge(:user => current_user))
  end
end

Given /^the following (.*) reports?:$/ do |type, table|
  table.hashes.each do |row|
    send(:"create_#{type}_report", row.symbolize_keys)
  end
end

Then /^I should see the following scores?:$/ do |table|
  table.map_column!('politician') {|name| Politician.with_name(name).first }
  table.hashes.each do |hash|
    Then %{I should see "#{hash['politician'].full_name}"}
    Then %{I should see "#{hash['score']}"}
    hash['politician'].report_scores.map {|s| s.score.round }.should include(hash['score'].to_i)
  end
end
