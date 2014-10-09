Given /^(bill "[^\"]*") has a roll on the question "([^\"]*)"$/ do |bill, question|
  create(:roll, subject: bill, question: question)
end

Given /^((?:bill|amendment) "[^\"]*") has the following rolls?:$/ do |bill_or_amendment, table|
  table.hashes.each do |hash|
    if hash['voted_at'].to_s.include?('.')
      hash['voted_at'] = eval(hash['voted_at'])
    end
    create(:roll, hash.merge(subject: bill_or_amendment))
  end
end
