Given /^(report ".*") has the following scores:$/ do |report, table|
  table.map_column!('politician') {|name| Politician.with_name(name).first }
  table.hashes.each do |hash|
    report.scores.create!(hash)
  end
end
