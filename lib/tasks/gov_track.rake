require 'open-uri'
require 'nokogiri'

MEETING = 111

namespace :gov_track do
  def gov_track_path(path)
    local_path = Rails.root.join('data/gov_track', path)
    File.exist?(local_path) ? local_path : "http://www.govtrack.us/data/#{path}"
  end

  namespace :bills do
    desc "Download Bills"
    task :download do
      `rsync -az govtrack.us::govtrackdata/us/111/bills .`
    end
  end

  namespace :votes do
    desc "Download Votes"
    task :download do
      `rsync -az govtrack.us::govtrackdata/us/111/rolls .`
      `wget http://www.govtrack.us/data/us/111/votes.all.index.xml`
    end

    def bill_ref(gov_track_bill_id)
      gov_track_bill_id.to_s.match(/([a-z]+)#{MEETING}-(\d+)/).captures.join
    end
    
    def opencongress_bill_id(gov_track_bill_id)
      "#{MEETING}-#{bill_ref(gov_track_bill_id)}"
    end

    def fetch_roll(gov_track_roll_id)
      Roll.find_or_create_by_opencongress_id(gov_track_roll_id).tap do |roll|
        data = Nokogiri::XML(open(gov_track_path("us/#{MEETING}/rolls/#{gov_track_roll_id}.xml"))).xpath('roll')
        raise data.inspect if data.size != 1
        data = data.first
        roll.update_attributes!({
          :where => data['where'],
          :voted_at => data['datetime'],
          :aye => data['aye'],
          :nay => data['nay'],
          :not_voting => data['nv'],
          :present => data['present'],
          :result => data.xpath('result').inner_text,
          :required => data.xpath('required').inner_text,
          :question => data.xpath('question').inner_text,
          :roll_type => data.xpath('type').inner_text,
          :congress => Congress.find_by_meeting(MEETING)
        })
        roll.update_attributes!(:votes => data.xpath('voter').map do |voter|
          politician = Politician.find_by_gov_track_id(voter['id'])
          (politician.votes.first(:conditions => {:roll_id => roll}) \
            || politician.votes.build(:roll => roll)).tap do |vote|
            vote.update_attributes!(:vote => voter['vote'])
          end
        end)
      end
    end

    def fetch_bill(gov_track_bill_id)
      (Bill.find_by_opencongress_id(opencongress_bill_id(gov_track_bill_id)) \
        || Bill.new(:opencongress_id => opencongress_bill_id(gov_track_bill_id))).tap do |bill|
        data = Nokogiri::XML(open(gov_track_path("us/#{MEETING}/bills/#{bill_ref(gov_track_bill_id)}.xml"))).xpath('bill')
        raise data.inspect if data.size != 1
        data = data.first
        raise [bill.title, data.xpath('titles')].inspect if bill.title.present?
        bill.update_attributes!(
          :gov_track_id => gov_track_bill_id,
          :congress => Congress.find_by_meeting(data['session']),
          :bill_type => data['type'],
          :bill_number => data['number'],
          :updated_at => data['updated'],
          :introduced_on => data.xpath('introduced').first['datetime'],
          :sponsor => Politician.find_by_gov_track_id(data.xpath('sponsor').first['id']),
          :summary => data.xpath('summary').inner_text.strip,
          :congress => Congress.find_by_meeting(MEETING)
        )
      end
    end

    desc "Process Votes"
    task :unpack => :environment do
      ActiveRecord::Base.transaction do
        doc = Nokogiri::XML(open(gov_track_path("us/#{MEETING}/votes.all.index.xml")))
        doc.xpath('votes/vote').each do |vote|
          begin
            vote = vote.attributes.except('roll', 'date', 'bill_title', 'counts')
            roll = fetch_roll(vote.delete('id'))
            if bill_id = vote.delete('bill')
              vote['bill'] = fetch_bill(bill_id)
            end
            roll.update_attributes!(vote)
          rescue => e
            raise [e, vote, roll].inspect
          end
        end
      end

      # doc.xpath('//vote').each do |vote|
      #   if vote.attributes["bill"] # Not all votes are associated with a bill      # 
      #     bill = Bill.find(:first, :conditions => {:session => bill_session, :bill_number => bill_number, :bill_type => bill_type})
      #     if bill
      #       roll_filename = Rails.root.join("public","system","rolls","#{bill_type}2009-#{roll}.xml")
      #       if File.exist?(roll_filename)
      #         roll_doc = Nokogiri::XML(open(roll_filename))
      #         roll_doc.xpath('//voter').each do |voter|
      #           gov_track_id = voter.attributes['id'].value
      #           vote = voter.attributes['vote'].value == '+'
      #           politician = Politician.find_by_gov_track_id(gov_track_id)
      #           Vote.create!(:politician_id => politician.id, :vote => vote, :bill_id => bill.id)
      #         end
      #       end
      #     end
      # 
      #   end
      # end

      #   Dir.glob(Rails.root.join("public","system","bills","*.xml")).each do |filename|
      #     doc     = Nokogiri::XML(open(filename))
      #     title   = doc.xpath('//title').text
      #     number  = doc.root.attributes["number"].value
      #     type    = doc.root.attributes["type"].value
      #     session = doc.root.attributes["session"].value
      # 
      #     Bill.create!(
      #       :title => title,
      #       :bill_type => type,
      #       :bill_number => number,
      #       :session => session)
      #   end
    end
  end

  namespace :politicians do
    desc "Process Politicians"
    task :unpack => :environment do
      doc = Nokogiri::XML(open(gov_track_path("us/#{MEETING}/people.xml")))
      congress = Congress.find_or_create_by_meeting(MEETING)

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
              attrs[method] = person[attr] if person[attr].present?
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
              attrs[method] = role[attr] if role[attr].present?
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