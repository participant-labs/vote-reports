Given /^(bill "[^\"]*") has the following votes:$/ do |bill, table|
  roll = create_roll(:subject => bill)
  table.map_column!('politician') {|name| Politician.with_name(name).first }
  table.hashes.each do |attrs|
    create_vote(attrs.symbolize_keys.merge(:roll => roll))
  end
end
