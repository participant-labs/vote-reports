require 'nokogiri'

Dir.glob(File.join(RAILS_ROOT,"public","system","bills","*.xml")).each do |filename|
  doc     = Nokogiri::XML(open(filename))
  title   = doc.xpath('//title').text
  number  = doc.root.attributes["number"].value
  type    = doc.root.attributes["type"].value
  session = doc.root.attributes["session"].value
  
  Bill.create!(
    :title => title, 
    :bill_type => type,
    :bill_number => number,
    :session => session) 
end
