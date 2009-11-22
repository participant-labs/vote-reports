class CreatePoliticians < ActiveRecord::Migration
  def self.up
    create_table :politicians do |t|
      t.string :first_name
      t.string :last_name
      t.string :vote_smart_id

      t.timestamps
    end
  end

  def self.down
    drop_table :politicians
  end
end
