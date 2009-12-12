Given /^the following politicians?:$/ do |table|
  table.hashes.each do |row|
    Factory.create(:politician, row.symbolize_keys)
  end
end

Given /^the following representative terms for "(.+)":$/ do |name, table|
  first, last = name.split(' ')
  politician = Politician.first(:conditions => {:first_name => first, :last_name => last})
  table.hashes.each do |row|
    Factory.create(:representative_term,
      row.symbolize_keys.merge(:politician => politician))
  end
end
