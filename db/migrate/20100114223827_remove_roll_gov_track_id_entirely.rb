class RemoveRollGovTrackIdEntirely < ActiveRecord::Migration
  def self.up
    remove_column :rolls, :gov_track_id
  end

  def self.down
    add_column :rolls, :gov_track_id, :string, :null => false
  end
end
