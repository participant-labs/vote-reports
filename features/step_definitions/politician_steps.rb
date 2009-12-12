Given /^the following politicians?:$/ do |table|
  table.hashes.each do |row|
    Factory.create(:politician, row.symbolize_keys)
  end
end

Given /^the following representative terms for "(.+)":$/ do |name, table|
  politician = Politician.find_by_full_name(name)
  table.hashes.each do |row|
    Factory.create(:representative_term,
      row.symbolize_keys.merge(:politician => politician))
  end
end

Given /^the following senate terms for "(.+)":$/ do |name, table|
  politician = Politician.find_by_full_name(name)
  table.hashes.each do |row|
    Factory.create(:senate_term, row.symbolize_keys.merge(:politician => politician))
  end
end
