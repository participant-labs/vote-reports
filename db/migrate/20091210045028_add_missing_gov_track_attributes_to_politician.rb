class AddMissingGovTrackAttributesToPolitician < ActiveRecord::Migration
  def self.up
    add_column :politicians, :metavid_id, :string
    add_column :politicians, :birthday, :date
    add_column :politicians, :religion, :string
  end

  def self.down
    remove_column :politicians, :metavid_id
    remove_column :politicians, :birthday
    remove_column :politicians, :religion
  end
end
