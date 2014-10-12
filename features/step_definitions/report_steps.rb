Transform /^report "([^\"]*)"$/ do |name|
  Report.find_by_name(name)
end

Given /^(I have |)an? (.*?) ?report named "([^\"]*)"$/ do |mine, type, name|
  params = mine.present? ? {user: current_user} : {}
  if type.present?
    create(:report, type.to_sym, params.merge(name: name))
  else
    create(:report, params.merge(name: name))
  end
end

Given /^(\d+) published reports$/ do |count|
  create_list(:report, count.to_i, :published)
end

Given /^I have the following (.*) reports?:$/ do |type, table|
  table.hashes.each do |row|
    create(:report, type, row.symbolize_keys.merge(user: current_user))
  end
end

Given /^the following (.*) reports?:$/ do |type, table|
  table.hashes.each do |row|
    create(:report, type, row.symbolize_keys)
  end
end

Given /^(\d+) published reports with (subject "[^"]*")$/ do |count, subject|
  create_list(:report, Integer(count), :published).each do |report|
    create(:report_subject, report: report, subject: subject)
  end
end

# for use reading score lists from a report page
Then /^I should see the following scores?:$/ do |table|
  table.map_column!('politician') {|name| Politician.with_name(name).first }
  table.hashes.each do |hash|
    step %{I should see "#{hash['politician'].last_name}"}
    expect(
      hash['politician'].report_scores.map {|s| s.score.round }
    ).to include(hash['score'].to_i)
    expect(page).to have_css(".report_score.for_politician_#{hash['politician'].id}", text: ReportScore.new(score: hash['score']).letter_grade)
  end
end

# for use reading score lists from a politician page
Then /^I should see the following report scores?:$/ do |table|
  table.hashes.each do |hash|
    step %{I should see "#{hash['name']}"} if hash['name'].present?
    expect(page).to have_css(".report_score", text: ReportScore.new(score: hash['score']).letter_grade)
  end
end

Then /^I should not see the following report scores?:$/ do |table|
  table.hashes.each do |hash|
    step %{I should not see "#{hash['name']}"} if hash['name'].present?
    expect(page).to_not have_css(".report_score", text: ReportScore.new(score: hash['score']).letter_grade)
  end
end
