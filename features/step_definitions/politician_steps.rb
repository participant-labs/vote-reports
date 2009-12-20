Given /^the following politicians?:$/ do |table|
  table.hashes.each do |row|
    create_politician(row.symbolize_keys)
  end
end

Given /^the following representative terms for "(.+)":$/ do |name, table|
  politician = Politician.find_by_full_name(name)
  table.hashes.each do |row|
    create_representative_term(row.symbolize_keys.merge(:politician => politician))
  end
end

Given /^the following senate terms for "(.+)":$/ do |name, table|
  politician = Politician.find_by_full_name(name)
  table.hashes.each do |row|
    create_senate_term(row.symbolize_keys.merge(:politician => politician))
  end
end
