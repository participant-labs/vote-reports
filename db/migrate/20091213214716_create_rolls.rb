class CreateRolls < ActiveRecord::Migration
  def self.up
    create_table :rolls do |t|
      t.string :where
      t.datetime :voted_at
      t.integer :aye
      t.integer :nay
      t.integer :not_voting
      t.integer :present
      t.string :result
      t.string :required
      t.string :question
      t.string :type
      t.string :opencongress_id
      t.references :bill
      t.references :congress

      t.timestamps
    end
  end

  def self.down
    drop_table :rolls
  end
end
