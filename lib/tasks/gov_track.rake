require 'open-uri'
require 'nokogiri'

namespace :gov_track do
  def gov_track_path(path)
    local_path = Rails.root.join('data/gov_track', path)
    File.exist?(local_path) ? local_path : "http://www.govtrack.us/data/#{path}"
  end

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
    desc "Process Politicians"
    task :unpack => :environment do
      meeting = 111
      doc = Nokogiri::XML(open(gov_track_path("us/#{meeting}/people.xml")))
      congress = Congress.find_or_create_by_meeting(meeting)

      ActiveRecord::Base.transaction do
        doc.xpath('people/person').each do |person|
          politician = Politician.find_or_create_by_gov_track_id(person['id'])
          politician.update_attributes({
              'lastname' => 'last_name',
              'firstname' => 'first_name',
              'bioguideid' => 'bioguide_id',
              'metavidid' => 'metavid_id',
              'birthday' => 'birthday',
              'gender' => 'gender',
              'religion' => 'religion'
            }.inject({}) do |attrs, (attr, method)|
              attrs[method] = person[attr]
              attrs
          end)

          person.xpath('role').each do |role|
            attrs = {
              'startdate' => 'started_on',
              'enddate' => 'ended_on',
              'url' => 'url',
              'party' => 'party',
              'state' => 'state',
            }.inject({}) do |attrs, (attr, method)|
              attrs[method] = role[attr]
              attrs
            end.merge(:congress => congress)

            case role['type']
            when 'rep'
              politician.representative_terms.find_or_create_by_started_on(role['startdate'].to_date) \
                .update_attributes(attrs.merge(:district => role['district']))
            when 'sen'
              politician.senate_terms.find_or_create_by_started_on(role['startdate'].to_date) \
                .update_attributes(attrs.merge(:senate_class => role['class']))
            else
              raise role.inspect
            end
          end
        end
      end
    end
  end

end