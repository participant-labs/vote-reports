Given /^(bill "[^\"]*") has a roll on the question "([^\"]*)"$/ do |bill, question|
  create_roll(:subject => bill, :question => question)
end

Given /^(bill "[^\"]*") has the following rolls?:$/ do |bill, table|
  table.hashes.each do |hash|
    if hash['voted_at'].to_s.include?('.')
      hash['voted_at'] = eval(hash['voted_at'])
    end
    create_roll(hash.merge(:subject => bill))
  end
end
