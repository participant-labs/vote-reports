And /^(report "[^\"]*") has the following bill criteria:$/ do |report, table|
  table.hashes.each do |attrs|
    attrs['report'] = report
    attrs['bill'] = Bill.with_title(attrs['bill']).first
    create_bill_criterion(attrs.symbolize_keys)
  end
end