namespace :gov_track do
  task :support => :environment do
    require 'open-uri'
    require 'nokogiri'

    MEETINGS = 101..111

    def gov_track_path(path)
      local_path = Rails.root.join('data/gov_track', path)
      File.exist?(local_path) ? local_path : "http://www.govtrack.us/data/#{path}"
    end

    def find_committee(name, source, node)
      if name == 'House Administration'
        name = 'House House Administration'
      end

      @committee_meetings[name] || begin
        congress_meeting = CommitteeMeeting.first(:conditions => {:name => name}) || begin
            committee = Committee.find_by_display_name(name)
            committee && committee.meetings.for_congress(@congress)
          end
        if congress_meeting.nil?
          raise "#{source} committee '#{name}' not found for #{node}"
          nil
        elsif congress_meeting.congress != @congress
          congress_meeting = congress_meeting.committee.meetings.for_congress(@congress).tap do |right_congress_meeting|
            if congress_meeting.name != right_congress_meeting.name
              puts "#{source} listed committee #{congress_meeting.inspect} via #{node}, when it should have listed #{right_congress_meeting.inspect}"
            end
          end
        end
        congress_meeting
      end
    end

    def find_subcommittee(committee_name, subcommittee_name, source, node)
      if committee_meeting = CommitteeMeeting.first(:conditions => {:name => committee_name, :congress_id => @congress.id})
        sub = committee_meeting.subcommittees.find_by_name(subcommittee_name) || begin
            parent_subcommittee_meetings = committee_meeting.committee.subcommittee_meetings
            corresponding_subcommittee_meetings = parent_subcommittee_meetings.select {|m| (m.name || m.committee.display_name).include?(subcommittee_name) }

            if corresponding_subcommittee_meetings.blank?
              raise("No subcommittee found for #{node}")
            elsif corresponding_subcommittee_meetings.size > 1 && corresponding_subcommittee_meetings.map(&:committee).uniq.size > 1
              raise "Multiple subcommittee_meetings for #{node.inspect}: #{corresponding_subcommittee_meetings}"
            else
              corresponding_subcommittee_meeting = corresponding_subcommittee_meetings.first
              puts("Selected #{corresponding_subcommittee_meeting.name} for #{subcommittee_name}")
              corresponding_subcommittee_meeting.committee.meetings.create!(:congress => @congress, :name => subcommittee_name)
            end
          end
        raise(sub.errors.full_messages.inspect) unless sub.valid?
        sub
      else
        raise "No committee found for #{node}"
      end
    end

    def chdir(path)
      FileUtils.mkdir_p(path)
      Dir.chdir(path) do
        yield
      end
    end

    def meetings(&block)
      ActiveRecord::Base.transaction do
        (ENV['MEETING'].present? ? [ENV['MEETING'].to_i] : MEETINGS).each do |meeting|
          @congress = Congress.find_or_create_by_meeting(meeting)
          Sunspot.batch do
            path = Rails.root.join("data/gov_track/us", meeting.to_s)
            chdir(path) do
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
    @politicians = Politician.all(:select => "id, gov_track_id, us_state_id").index_by {|p| p.gov_track_id }
  end

  task :download_all => :support do
    Exceptional.rescue_and_reraise do
      log = Rails.root.join('log/govtrack-rsync.log')
      chdir(Rails.root.join("data/gov_track/us/")) do
        `wget -N http://www.govtrack.us/data/us/people.xml >> #{log}`
        `wget -N http://www.govtrack.us/data/us/committees.xml >> #{log}`
      end
      meetings do |meeting|
        `wget -N http://www.govtrack.us/data/us/#{meeting}/committees.xml >> #{log}`
        `wget -N http://www.govtrack.us/data/us/#{meeting}/people.xml  >> #{log}`
        `rsync -avz govtrack.us::govtrackdata/us/#{meeting}/bills . >> #{log}`
        `rsync -avz govtrack.us::govtrackdata/us/#{meeting}/bills.amdt . >> #{log}`
        `rsync -avz govtrack.us::govtrackdata/us/#{meeting}/rolls . >> #{log}`
      end
    end
  end

end