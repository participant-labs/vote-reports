require 'open-uri'
require 'nokogiri'

MEETINGS = 103..111

namespace :gov_track do
  task :support => :environment do
    def gov_track_path(path)
      local_path = Rails.root.join('data/gov_track', path)
      File.exist?(local_path) ? local_path : "http://www.govtrack.us/data/#{path}"
    end
  end

  task :politicians => :environment do
    @politicians = Politician.all(:select => "id, gov_track_id").index_by {|p| p.gov_track_id }
  end

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
        `rsync -az govtrack.us::govtrackdata/us/#{meeting}/bills.amdt .`
        `rsync -az govtrack.us::govtrackdata/us/#{meeting}/rolls .`
      end
    end
  end

  namespace :votes do
    def fetch_roll(gov_track_roll_id, attrs)
      Roll.find_by_gov_track_id(gov_track_roll_id) || begin
        data = Nokogiri::XML(open(gov_track_path("us/#{@congress.meeting}/rolls/#{gov_track_roll_id}.xml"))).at('roll')
        roll = Roll.create(attrs.symbolize_keys.merge(
          :gov_track_id => gov_track_roll_id,
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

    def fetch_votes_via_votes_index(votes_index_path)
      puts "Fetching votes via vote index"
      Nokogiri::XML(open(votes_index_path)).xpath('votes/vote').each do |vote|
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
    end

    def fetch_votes_via_directory_traversal
      puts "Fetching votes via directory traversal"
      puts "Not implemented"
    end

    desc "Process Votes"
    task :unpack => [:support, :politicians] do
      ActiveRecord::Base.transaction do
        @politicians = Politician.all(:select => "id, gov_track_id").index_by {|p| p.gov_track_id }
        MEETINGS.each do |meeting|
          puts "Meeting #{meeting}"
          @congress = Congress.find_or_create_by_meeting(meeting)
          votes_index_path = gov_track_path("us/#{meeting}/votes.all.index.xml")
          if File.exist?(votes_index_path)
            fetch_votes_via_votes_index(votes_index_path)
          else
            fetch_votes_via_directory_traversal
          end
          puts
        end
      end
    end
  end

end