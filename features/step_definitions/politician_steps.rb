Transform /politician "(.+)"/ do |name|
  Politician.with_name(name).first
end

Given /^the following representative terms for (politician ".+"):$/ do |politician, table|
  table.hashes.each do |row|
    create_representative_term(row.symbolize_keys.merge(:politician => politician))
  end
end

Given /^the following senate terms for (politician ".+"):$/ do |politician, table|
  table.hashes.each do |row|
    create_senate_term(row.symbolize_keys.merge(:politician => politician))
  end
end
