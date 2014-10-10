Transform /subject "([^\"]*)"/ do |subject|
  Subject.find_or_create_by(name: subject)
end

Given /^(bill "[^\"]*") has (subject "[^\"]*")$/ do |bill, subject|
  bill.subjects << subject
end

Given /^(report "[^"]*") has (subject "[^"]*")$/ do |report, subject|
  create(:report_subject, report: report, subject: subject)
end

Given /^(\d+) subjects? with (\d+) bills? each$/ do |subject_count, bill_count|
  subject_count.to_i.times do
    bills = ([nil] * bill_count.to_i).map { new_bill }
    create(:subject, bills: bills)
  end
end

Given /^(\d+) bills? with (subject "[^\"]*")$/ do |bill_count, subject|
  create_list(:bill, bill_count.to_i, subjects: [subject])
end

Given /^(\d+) report bills? with (subject "[^\"]*")$/ do |report_bill_count, subject|
  report = create(:report, :published)
  report_bill_count.to_i.times do
    bill = create(:bill, subjects: [subject])
    create(:bill_criterion, bill: bill, report: report)
  end
end

Given /^(\d+) subjects? with (\d+) report bills? each$/ do |subject_count, report_bill_count|
  report = create(:report, :published)
  subject_count.to_i.times do
    bills = ([nil] * report_bill_count.to_i).map { new_bill }
    create(:subject, bills: bills)
    bills.each do |bill|
      create(:bill_criterion, bill: bill, report: report)
    end
  end
end
