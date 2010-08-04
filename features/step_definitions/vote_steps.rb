Given /^(bill "[^\"]*") has the following passage votes(?: on "(.*)"|):$/ do |bill, voted_at, table|
  roll = create_roll(:subject => bill, :roll_type => "On Passage", :voted_at => voted_at)
  table.map_column!('politician') {|name| Politician.with_name(name).first }
  table.hashes.each do |attrs|
    next if attrs['vote'].blank?
    create_vote(attrs.symbolize_keys.merge(:roll => roll))
  end
end

Given /^the following bill passage votes:$/ do |table|
  table.map_column!('politician') {|name| Politician.with_name(name).first }
  table.hashes.each do |attrs|
    politician = attrs.delete('politician')
    @rolls ||= attrs.keys.inject({}) do |rolls, bill|
      rolls[bill] = create_roll(:subject => Bill.with_title(bill).first, :roll_type => "On Passage")
      rolls
    end

    attrs.each_pair do |bill, vote|
      next if vote.blank?
      create_vote(:politician => politician, :roll => @rolls[bill], :vote => vote)
    end
  end
end

Given /^((?:bill|amendment) "[^\"]*") has the following roll votes:$/ do |bill_or_amendment, table|
  table.map_column!('politician') {|name| Politician.with_name(name).first }
  table.hashes.each do |attrs|
    politician = attrs.delete('politician')
    rolls = attrs.keys.inject({}) do |rolls, roll_type|
      rolls[roll_type] = bill_or_amendment.rolls.find_by_roll_type(roll_type)
      raise "Roll type '#{roll_type}' not found" unless rolls[roll_type]
      rolls
    end

    attrs.each_pair do |roll_type, vote|
      next if vote.blank?
      create_vote(:politician => politician, :roll => rolls[roll_type], :vote => vote)
    end
  end
end
