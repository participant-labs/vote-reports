require 'open-uri'
require 'nokogiri'

MEETINGS = 103..111

namespace :gov_track do
  task :support => :environment do
    def gov_track_path(path)
      local_path = Rails.root.join('data/gov_track', path)
      File.exist?(local_path) ? local_path : "http://www.govtrack.us/data/#{path}"
    end

    def find_committee_meeting_by_committee(committee)
      if committee
        committee.meetings.find_by_congress_id(@congress.id) \
          || committee.meetings.create!(:congress_id => @congress.id, :name => committee.display_name, :committee_id => committee.id)
      end
    end

    def find_committee(name, source, node)
      if name == 'House Administration'
        name = 'House House Administration'
      end

      @committees[name] || begin
        congress_meeting = CommitteeMeeting.first(:conditions => {:name => name}) \
          || find_committee_meeting_by_committee(Committee.find_by_display_name(name))
        if congress_meeting.nil?
          puts "#{source} committee '#{name}' not found for #{node}"
          nil
        elsif congress_meeting.congress != @congress
          congress_meeting = find_committee_meeting_by_committee(congress_meeting.committee).tap do |right_congress_meeting|
            if congress_meeting.name != right_congress_meeting.name
              puts "#{source} listed committee #{congress_meeting.inspect} via #{node}, when it should have listed #{right_congress_meeting.inspect}"
            end
          end
        end
        congress_meeting
      end
    end

    def find_subcommittee(committee_name, subcommittee_name, source, node)
      subcommittee_meeting = find_committee(subcommittee_name, source, node)
      if subcommittee_meeting
        parent = subcommittee_meeting.committee.parent
        unless [parent.display_name, *parent.meetings.map(&:name)].compact.include?(committee_name)
          puts "Skipping subcommittee '#{subcommittee_meeting.name}' which wasn't found under '#{committee_name}', but under '#{parent.display_name}' / '#{parent.meetings.find_by_congress_id(@congress.id).try(:name) }'"
          return nil
        end
      end
      subcommittee_meeting
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