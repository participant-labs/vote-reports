Transform /subject "([^\"]*)"/ do |subject|
  Subject.find_or_create_by_name(subject)
end

Given /^(bill "[^\"]*") has a (subject "[^\"]*")$/ do |bill, subject|
  bill.subjects << subject
end

Given /^(\d+) subjects? with (\d+) bills? each$/ do |subject_count, bill_count|
  subject_count.to_i.times do
    bills = ([nil] * bill_count.to_i).map { new_bill }
    create_subject(:bills => bills)
  end
end

Given /^(\d+) bills? with (subject "[^\"]*")$/ do |bill_count, subject|
  bill_count.to_i.times do
    create_bill(:subjects => [subject])
  end
  ReportSubject.generate!
end

Given /^(\d+) report bills? with (subject "[^\"]*")$/ do |report_bill_count, subject|
  report = create_published_report
  report_bill_count.to_i.times do
    bill = create_bill(:subjects => [subject])
    create_bill_criterion(:bill => bill, :report => report)
  end
  ReportSubject.generate!
end

Given /^(\d+) subjects? with (\d+) report bills? each$/ do |subject_count, report_bill_count|
  report = create_published_report
  subject_count.to_i.times do
    bills = ([nil] * report_bill_count.to_i).map { new_bill }
    create_subject(:bills => bills)
    bills.each do |bill|
      create_bill_criterion(:bill => bill, :report => report)
    end
  end
  ReportSubject.generate!
end
