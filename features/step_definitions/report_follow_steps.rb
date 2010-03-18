Given /(user ".*") is following (report ".*")/ do |user, report|
  report.followers << user
end
