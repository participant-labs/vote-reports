require 'nokogiri'

filename = File.join(RAILS_ROOT,"public","system","votes.all.index.xml")
doc = Nokogiri::XML(open(filename))

doc.xpath('//vote').each do |vote|
  if vote.attributes["bill"] # Not all votes are associated with a bill
    roll = vote.attributes["roll"].value   
    bill = vote.attributes["bill"].value 
    bill_session = bill.match(/[a-z+](\d+)-/)[1]
    bill_number = bill.match(/-(\d+)/)[1]
    bill_type = bill[0,1]

    bill = Bill.find(:first, :conditions => {:session => bill_session, :bill_number => bill_number, :bill_type => bill_type})
    if bill
      roll_filename = File.join(RAILS_ROOT,"public","system","rolls","#{bill_type}2009-#{roll}.xml")
      if File.exist?(roll_filename)
        roll_doc = Nokogiri::XML(open(roll_filename))
        roll_doc.xpath('//voter').each do |voter|
          gov_track_id = voter.attributes['id'].value  
          vote = voter.attributes['vote'].value == '+'
          politician = Politician.find_by_gov_track_id(gov_track_id)
          Vote.create!(:politician_id => politician.id, :vote => vote, :bill_id => bill.id)
        end
      end
    end

  end
end
