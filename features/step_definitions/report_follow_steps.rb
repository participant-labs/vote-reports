Given /(user ".*") is following (report ".*")/ do |user, report|
  report.followers << user
end

Given /I am following (report ".*")/ do |report|
  report.followers << current_user
end
