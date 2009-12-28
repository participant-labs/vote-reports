class BillsHaveSeparateGovTrackUpdatedAt < ActiveRecord::Migration
  def self.up
    add_column :bills, :gov_track_updated_at, :datetime
  end

  def self.down
    remove_column :bills, :gov_track_updated_at
  end
end
