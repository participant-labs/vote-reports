Given /^(report "[^\"]*") has the following bill criteri(?:a|on):$/ do |report, table|
  table.map_column!('bill') {|title| Bill.with_title(title).first }
  table.hashes.each do |attrs|
    create_bill_criterion(attrs.symbolize_keys.merge(:report => report))
  end
end

Given /^(interest group "[^\"]*") has the following bill criteri(?:a|on):$/ do |interest_group, table|
  table.map_column!('bill') {|title| Bill.with_title(title).first }
  table.hashes.each do |attrs|
    create_bill_criterion(attrs.symbolize_keys.merge(:report => interest_group.report))
  end
end

When /I remove a bill criterion from (report ".+")/ do |report|
  visit user_report_bill_criteria_path(report.user, report)
  click_link "Remove"
  Then %{I should see "Successfully deleted report criterion"}
end