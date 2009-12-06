require 'nokogiri'

filename = File.join(RAILS_ROOT,"public","system","people.xml")
doc = Nokogiri::XML(open(filename))

doc.xpath('//person').each do |person|
  first_name = person.attributes["firstname"].value
  last_name = person.attributes["lastname"].value
  gov_track_id = person.attributes["id"].value
  Politician.create!(
    :first_name => first_name,
    :last_name => last_name,
    :gov_track_id => gov_track_id
  )
end
