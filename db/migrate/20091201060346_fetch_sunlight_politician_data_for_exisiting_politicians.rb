class FetchSunlightPoliticianDataForExisitingPoliticians < ActiveRecord::Migration
  def self.up
    transaction do
      Politician.all.each do |politician|
        politician.load_sunlight_labs_data
        politician.save!
      end
    end
  end

  def self.down
  end
end
