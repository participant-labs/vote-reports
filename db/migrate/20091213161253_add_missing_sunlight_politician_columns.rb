class AddMissingSunlightPoliticianColumns < ActiveRecord::Migration
  def self.up
    Politician.find_by_gov_track_id(412283).update_attributes!(:crp_id => nil)
    Politician.find_by_gov_track_id(400169).update_attributes!(:vote_smart_id => nil)
    add_column :politicians, :official_rss, :string
  end

  def self.down
    remove_column :politicians, :official_rss
  end
end
