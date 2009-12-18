Given /^the following politicians?:$/ do |table|
  table.hashes.each do |row|
    Politician.make(row.symbolize_keys)
  end
end

Given /^the following representative terms for "(.+)":$/ do |name, table|
  politician = Politician.find_by_full_name(name)
  table.hashes.each do |row|
    RepresentativeTerm.make(row.symbolize_keys.merge(:politician => politician))
  end
end

Given /^the following senate terms for "(.+)":$/ do |name, table|
  politician = Politician.find_by_full_name(name)
  table.hashes.each do |row|
    SenateTerm.make(row.symbolize_keys.merge(:politician => politician))
  end
end
