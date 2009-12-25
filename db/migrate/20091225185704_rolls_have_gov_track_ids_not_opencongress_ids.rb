class RollsHaveGovTrackIdsNotOpencongressIds < ActiveRecord::Migration
  def self.up
    rename_column :rolls, :opencongress_id, :gov_track_id
  end

  def self.down
    rename_column :rolls, :gov_track_id, :opencongress_id
  end
end
