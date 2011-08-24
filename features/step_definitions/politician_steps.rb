Transform /politician "(.+)"/ do |name|
  Politician.with_name(name).first
end

Given /^the following (representative|senate|presidential) terms for (politician ".+"):$/ do |type, politician, table|
  table.hashes.each do |row|
    send(:"create_#{type}_term", row.symbolize_keys.merge(:politician => politician))
  end
  Politician.update_current_office_status!(quiet: true)
end
