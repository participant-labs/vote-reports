Given /^the following politicians?:$/ do |table|
  table.hashes.each do |row|
    Factory.create(:politician, row.symbolize_keys)
  end
end
