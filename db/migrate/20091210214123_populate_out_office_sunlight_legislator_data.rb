class PopulateOutOfficeSunlightLegislatorData < ActiveRecord::Migration
  def self.up
    Politician.all(:conditions => {:gov_track_id => nil}).each do |politician|
      politician.load_sunlight_labs_data
      politician.save
    end
  end

  def self.down
  end
end
