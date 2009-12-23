require 'open-uri'
require 'nokogiri'

MEETINGS = 103..111

namespace :gov_track do
  task :download_all do
    Dir.chdir(Rails.root.join("data/gov_track/us/")) do
      `wget -N http://www.govtrack.us/data/us/people.xml`
    end
    MEETINGS.each do |meeting|
      dest = Rails.root.join("data/gov_track/us/#{meeting}/")
      FileUtils.mkdir_p(dest)
      Dir.chdir(dest) do
        `wget -N http://www.govtrack.us/data/us/#{meeting}/votes.all.index.xml`
        `wget -N http://www.govtrack.us/data/us/#{meeting}/people.xml`
        `rsync -az govtrack.us::govtrackdata/us/#{meeting}/bills .`
        `rsync -az govtrack.us::govtrackdata/us/#{meeting}/rolls .`
      end
    end
  end

  def gov_track_path(path)
    local_path = Rails.root.join('data/gov_track', path)
    File.exist?(local_path) ? local_path : "http://www.govtrack.us/data/#{path}"
  end

  namespace :votes do
    def bill_ref(gov_track_bill_id)
      gov_track_bill_id.to_s.match(/([a-z]+)#{@congress.meeting}-(\d+)/).captures.join
    end
    
    def opencongress_bill_id(gov_track_bill_id)
      "#{@congress.meeting}-#{bill_ref(gov_track_bill_id)}"
    end

    def fetch_roll(gov_track_roll_id, attrs)
      if roll = Roll.find_by_opencongress_id(gov_track_roll_id)
        return roll
      else
        data = Nokogiri::XML(open(gov_track_path("us/#{@congress.meeting}/rolls/#{gov_track_roll_id}.xml"))).at('roll')
        roll = Roll.create(attrs.symbolize_keys.merge(
          :opencongress_id => gov_track_roll_id,
          :congress => @congress,
          :where => data['where'].to_s,
          :voted_at => data['datetime'].to_s,
          :aye => data['aye'].to_s,
          :nay => data['nay'].to_s,
          :not_voting => data['nv'].to_s,
          :present => data['present'].to_s,
          :result => data.at('result').inner_text,
          :required => data.at('required').inner_text,
          :question => data.at('question').inner_text,
          :roll_type => data.at('type').inner_text,
          :congress => @congress)
        )
        inserts = data.xpath('voter').map { |vote|
          voter = @politicians[vote['id'].to_i]
          if voter.nil?
            puts "Ignoring #{vote.inspect}"
            next
          end
          ["'#{vote['vote']}'", voter.id, roll.id].join(', ')
        }.compact.join("), (")
        ActiveRecord::Base.connection.execute(%{
          INSERT INTO "votes" (vote, politician_id, roll_id) VALUES
            (#{ inserts });
        })
      end
    end

    def fetch_bill(gov_track_bill_id)
      (Bill.find_by_opencongress_id(opencongress_bill_id(gov_track_bill_id)) \
        || Bill.new(:opencongress_id => opencongress_bill_id(gov_track_bill_id))).tap do |bill|
        data =
          begin
            Nokogiri::XML(open(gov_track_path("us/#{@congress.meeting}/bills/#{bill_ref(gov_track_bill_id)}.xml"))).at('bill')
          rescue => e
            puts "#{e.inspect} #{gov_track_path("us/#{@congress.meeting}/bills/#{bill_ref(gov_track_bill_id)}.xml")}"
            return nil
          end
        raise "Something is weird #{@congress.meeting} != #{data['session']}" if @congress.meeting != data['session'].to_i
        bill.update_attributes!(
          :gov_track_id => gov_track_bill_id,
          :congress => @congress,
          :title => data.css('titles > title[type=official]').inner_text,
          :bill_type => data['type'].to_s,
          :bill_number => data['number'].to_s,
          :updated_at => data['updated'].to_s,
          :introduced_on => data.at('introduced')['datetime'].to_s,
          :sponsor => @politicians.fetch(data.at('sponsor')['id'].to_i),
          :summary => data.at('summary').inner_text.strip,
          :congress => @congress
        )
      end
    end

    desc "Process Votes"
    task :unpack => :environment do
      ActiveRecord::Base.transaction do
        @politicians = Politician.all(:select => "id, gov_track_id").index_by {|p| p.gov_track_id }
        MEETINGS.each do |meeting|
          puts "Meeting #{meeting}"
          @congress = Congress.find_or_create_by_meeting(meeting)
          doc = Nokogiri::XML(open(gov_track_path("us/#{meeting}/votes.all.index.xml")))
          doc.xpath('votes/vote').each do |vote|
            next unless vote['bill'].present? && bill = fetch_bill(vote.delete('bill').to_s)
            vote = vote.attributes.except('roll', 'date', 'bill_title', 'counts', 'title')
            amendment_title = vote.delete('amendment_title').to_s
            vote[:subject] =
              if (amendment_id = vote.delete('amendment').to_s).present?
                bill.amendments.first(:conditions => {:gov_track_id => amendment_id}) \
                  || bill.amendments.build(:gov_track_id => amendment_id, :title => amendment_title)
              else
                bill
              end
            fetch_roll(vote.delete('id').to_s, vote)
            $stdout.print "."
            $stdout.flush
          end
          puts
        end
      end
    end
  end

  namespace :politicians do
    desc "Process Politicians"
    task :unpack => :environment do
      data_path = ENV['MEETING'] ? "us/#{ENV['MEETING']}/people.xml" : "us/people.xml"
      doc = Nokogiri::XML(open(gov_track_path(data_path)))

      ActiveRecord::Base.transaction do
        doc.xpath('people/person').each do |person|
          politician = Politician.find_or_create_by_gov_track_id(person['id'])
          politician.update_attributes({
              'lastname' => 'last_name',
              'middlename' => 'middle_name',
              'firstname' => 'first_name',
              'bioguideid' => 'bioguide_id',
              'metavidid' => 'metavid_id',
              'osid' => 'open_secrets_id',
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
              'party' => 'party'
            }.inject({}) do |attrs, (attr, method)|
              attrs[method] = role[attr] if role[attr].present?
              attrs
            end

            case role['type']
            when 'rep'
              politician.representative_terms.find_or_create_by_started_on(role['startdate'].to_date) \
                .update_attributes(attrs.merge(:district => role['district'], :state => role['state']))
            when 'sen'
              politician.senate_terms.find_or_create_by_started_on(role['startdate'].to_date) \
                .update_attributes(attrs.merge(:senate_class => role['class'], :state => role['state']))
            when 'prez'
              politician.presidential_terms.find_or_create_by_started_on(role['startdate'].to_date) \
                .update_attributes(attrs)
            else
              raise role.inspect
            end
          end
        end
      end
    end
  end

end