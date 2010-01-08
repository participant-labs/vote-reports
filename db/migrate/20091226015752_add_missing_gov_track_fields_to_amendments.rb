class AddMissingGovTrackFieldsToAmendments < ActiveRecord::Migration
  def self.up
    transaction do
      remove_column :amendments, :gov_track_id
      add_column :amendments, :number, :integer
      add_column :amendments, :chamber, :string
      add_column :amendments, :offered_on, :date
      add_column :amendments, :sponsor_id, :integer
      add_column :amendments, :sponsor_type, :string
      rename_column :amendments, :title, :description
      add_column :amendments, :purpose, :text
      add_column :amendments, :sequence, :integer
      add_column :amendments, :congress_id, :integer
    end
  end

  def self.down
    transaction do
      add_column :amendments, :gov_track_id, :integer
      remove_column :amendments, :number
      remove_column :amendments, :chamber
      remove_column :amendments, :offered_on
      remove_column :amendments, :sponsor_id
      rename_column :amendments, :description, :title
      remove_column :amendments, :purpose
      remove_column :amendments, :sequence
      remove_column :amendments, :congress_id
    end
  end
end
