class PopulateBillGovTrackIdFromOpencongressId < ActiveRecord::Migration
  def self.up
    transaction do
      Bill.all(:conditions => {:gov_track_id => nil}).each do |bill|
        meeting, type, number = bill.opencongress_id.match(/(\d+)-(.+?)(\d+)/).captures
        congress = Congress.find_or_create_by_meeting(meeting.to_i)
        bill.update_attributes!(:gov_track_id => "#{type}#{meeting}-#{number}", :congress => congress)
      end
    end
  end

  def self.down
  end
end
