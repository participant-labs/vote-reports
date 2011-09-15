Transform /interest group "(.*)"/ do |name|
  InterestGroup.find_by_name(name)
end

Given /an interest group named "(.*)"/ do |name|
  create_interest_group(name: name)
end

Given /^(interest group "[^"]*") has the following ratings:$/ do |interest_group, table|
  table.map_column!('politician') {|name| Politician.with_name(name).first }
  table.map_column!('report') {|timespan|
    interest_group.reports.find_by_timespan(timespan) \
      || create_interest_group_report(
          :interest_group => interest_group, timespan: timespan)
  }
  table.hashes.each do |hash|
    create_interest_group_rating(
      hash.merge(
        :interest_group_report => hash.delete('report'),
        :numeric_rating => hash['rating'].to_f))
  end
end

Given /^the scores for (interest group "[^"]*") are calculated$/ do |interest_group|
  interest_group.rescore!
  Delayed::Worker.new(quiet: true).work_off(1).should == [1, 0]
end
