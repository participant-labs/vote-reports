class AddGovTrackColumsToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :gov_track_id, :string
    add_column :bills, :congress_id, :integer
    add_column :bills, :sponsor_id, :integer
    add_column :bills, :introduced_on, :date
    add_column :bills, :summary, :text
  end

  def self.down
    remove_column :bills, :gov_track_id
    remove_column :bills, :congress_id
    remove_column :bills, :sponsor_id
    remove_column :bills, :introduced_on
    remove_column :bills, :summary
  end
end
