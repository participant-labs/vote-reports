Given /^(bill "[^\"]*") has the following votes:$/ do |bill, table|
  roll = create_roll(:subject => bill)
  table.map_column!('politician') {|name| Politician.with_name(name).first }
  table.hashes.each do |attrs|
    next if attrs['vote'].blank?
    create_vote(attrs.symbolize_keys.merge(:roll => roll))
  end
end

Given /^the following votes:$/ do |table|
  table.map_column!('politician') {|name| Politician.with_name(name).first }
  table.hashes.each do |attrs|
    politician = attrs.delete('politician')
    attrs.each_pair do |bill, vote|
      next if vote.blank?
      roll = create_roll(:subject => Bill.with_title(bill).first)
      create_vote(:politician => politician, :roll => roll, :vote => vote)
    end
  end
end
