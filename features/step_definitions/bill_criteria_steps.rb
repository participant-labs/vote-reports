Given /^(report "[^\"]*") has the following (.*) criteri(?:a|on):$/ do |report, criterion_type, table|
  type = criterion_type.classify.constantize
  table.map_column!(criterion_type) {|title| type.with_title(title).first }
  table.hashes.each do |attrs|
    send(:"create_#{criterion_type}_criterion", attrs.symbolize_keys.merge(:report => report))
  end
end

Given /^(interest group "[^\"]*") has the following (.*) criteri(?:a|on):$/ do |interest_group, criterion_type, table|
  type = criterion_type.classify.constantize
  table.map_column!(criterion_type) {|title| type.with_title(title).first }
  table.hashes.each do |attrs|
    send(:"create_#{criterion_type}_criterion", attrs.symbolize_keys.merge(:report => interest_group.report))
  end
end

When /I remove a bill criterion from (report ".+")/ do |report|
  visit user_report_bill_criteria_path(report.user, report)
  click_link "Remove"
  Then %{I should see "Successfully deleted report criterion"}
end
