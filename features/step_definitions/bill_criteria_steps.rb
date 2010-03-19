Given /^(report "[^\"]*") has the following bill criteri(?:a|on):$/ do |report, table|
  table.map_column!('bill') {|title| Bill.with_title(title).first }
  table.hashes.each do |attrs|
    create_bill_criterion(attrs.symbolize_keys.merge(:report => report))
  end
end

When /I remove a bill criterion from (report ".+")/ do |report|
  visit edit_user_report_bills_path(current_user, report)
  click_link "Remove"
  Then %{I should see "Successfully deleted report criterion"}
end