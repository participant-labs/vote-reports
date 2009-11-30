class AddGovTrackIdToPoliticians < ActiveRecord::Migration
  def self.up
    add_column :politicians, :gov_track_id, :integer
  end

  def self.down
    remove_column :politicians, :gov_track_id
  end
end
