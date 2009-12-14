class CreateAmendments < ActiveRecord::Migration
  def self.up
    create_table :amendments do |t|
      t.integer :bill_id
      t.string :gov_track_id
      t.text :title

      t.timestamps
    end
  end

  def self.down
    drop_table :amendments
  end
end
