require 'open-uri'
require 'nokogiri'

MEETINGS = 103..111

namespace :gov_track do
  task :support => [:environment, :'sunspot:solr:start'] do
    def gov_track_path(path)
      local_path = Rails.root.join('data/gov_track', path)
      File.exist?(local_path) ? local_path : "http://www.govtrack.us/data/#{path}"
    end

    def find_committee(name, source, node)
      @committees[name] || begin
        wrong_congress_meeting = CommitteeMeeting.first(:conditions => {:name => name})
        if wrong_congress_meeting.nil?
          puts "#{source} listed committee '#{name}' via #{node} which wasn't found"
        else
          wrong_congress_meeting.committee.meetings.find_by_congress_id(@congress.id).tap do |right_congress_meeting|
            puts "#{source} listed committee #{wrong_congress_meeting.inspect} via #{node}, when it should have listed #{right_congress_meeting.inspect}"
          end
        end
      end
    end

    def meetings(&block)
      ActiveRecord::Base.transaction do
        (ENV['MEETING'].present? ? [ENV['MEETING'].to_i] : MEETINGS).each do |meeting|
          @congress = Congress.find_or_create_by_meeting(meeting)
          Sunspot.batch do
            Dir.chdir(Rails.root.join("data/gov_track/us/#{meeting}")) do
              yield meeting
            end
          end
        end
      end
    end

  end

  task :politicians => :environment do
    def politician(gov_track_id)
      @politicians.fetch(gov_track_id.to_i) do
        raise "Couldn't find politician: #{gov_track_id}"
      end
    end
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
        `wget -N http://www.govtrack.us/data/us/#{meeting}/committees.xml`
        `wget -N http://www.govtrack.us/data/us/#{meeting}/votes.all.index.xml`
        `wget -N http://www.govtrack.us/data/us/#{meeting}/people.xml`
        `rsync -az govtrack.us::govtrackdata/us/#{meeting}/bills .`
        `rsync -az govtrack.us::govtrackdata/us/#{meeting}/bills.amdt .`
        `rsync -az govtrack.us::govtrackdata/us/#{meeting}/rolls .`
      end
    end
  end

end