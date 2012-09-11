Transform /^report "([^\"]*)"$/ do |name|
  Report.find_by_name(name)
end

Given /^(I have |)an? (.*?) ?report named "([^\"]*)"$/ do |mine, type, name|
  params = mine.present? ? {user: current_user} : {}
  creator = type.present? ? :"create_#{type}_report" : :create_report
  send(creator, params.merge(name: name))
end

Given /^(\d+) published reports$/ do |count|
  count.to_i.times do
    create_published_report
  end
end

Given /^I have the following (.*) reports?:$/ do |type, table|
  table.hashes.each do |row|
    send(:"create_#{type}_report", row.symbolize_keys.merge(user: current_user))
  end
end

Given /^the following (.*) reports?:$/ do |type, table|
  table.hashes.each do |row|
    send(:"create_#{type}_report", row.symbolize_keys)
  end
end

Given /^(\d+) published reports with (subject "[^"]*")$/ do |count, subject|
  Integer(count).times do
    report = create_published_report
    create_report_subject(report: report, subject: subject)
  end
end

# for use reading score lists from a report page
Then /^I should see the following scores?:$/ do |table|
  table.map_column!('politician') {|name| Politician.with_name(name).first }
  table.hashes.each do |hash|
    step %{I should see "#{hash['politician'].last_name}"}
    hash['politician'].report_scores.map {|s| s.score.round }.should include(hash['score'].to_i)
    step %{I should see "#{ReportScore.new(score: hash['score']).letter_grade}" within ".report_score.for_politician_#{hash['politician'].id}"}
  end
end

# for use reading score lists from a politician page
Then /^I should see the following report scores?:$/ do |table|
  table.hashes.each do |hash|
    step %{I should see "#{hash['name']}"} if hash['name'].present?
    step %{I should see "#{ReportScore.new(score: hash['score']).letter_grade}" within ".report_score"}
  end
end

Then /^I should not see the following report scores?:$/ do |table|
  table.hashes.each do |hash|
    step %{I should not see "#{hash['name']}"} if hash['name'].present?
    step %{I should not see "#{ReportScore.new(score: hash['score']).letter_grade}" within ".report_score"}
  end
end
