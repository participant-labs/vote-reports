require 'nokogiri'

namespace :gov_track do
  desc "do everything"
  task :update => [:download, :unpack]

  desc "Download All Data"
  task :download => [:'bills:download', :'votes:download', :'politicians:download']

  desc "Process All Data"
  task :unpack => [:'bills:unpack', :'votes:unpack', :'politicians:unpack']

  namespace :bills do
    desc "Download Bills"
    task :download do
      `rsync -az govtrack.us::govtrackdata/us/111/bills .`
    end
    
    desc "Process Bills"
    task :unpack => :environment do
      Dir.glob(Rails.root.join("public","system","bills","*.xml")).each do |filename|
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
    end
  end
  
  namespace :votes do
    desc "Download Votes"
    task :download do
      `rsync -az govtrack.us::govtrackdata/us/111/rolls .`
      `wget http://www.govtrack.us/data/us/111/votes.all.index.xml`
    end
    
    desc "Process Votes"
    task :unpack => :environment do
      filename = Rails.root.join("public","system","votes.all.index.xml")
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
            roll_filename = Rails.root.join("public","system","rolls","#{bill_type}2009-#{roll}.xml")
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
      
    end
  end
  
  namespace :politicians do
    desc "Download Politicians"
    task :download do
      `wget http://www.govtrack.us/data/us/111/people.xml`
    end
    
    desc "Process Politicians"
    task :unpack => :environment do
      filename = Rails.root.join("public","system","people.xml")
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
    end
  end

end