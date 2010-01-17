class AddIndexesToRolls < ActiveRecord::Migration
  def self.up
    add_index :votes, :vote
    add_index :votes, :politician_id
    add_index :rolls, :roll_type
    add_index :rolls, :subject_type
    add_index :rolls, [:subject_type, :subject_id]
  end

  def self.down
    remove_index :votes, :vote
    remove_index :votes, :politician_id
    remove_index :rolls, :roll_type
    remove_index :rolls, :subject_type
    remove_index :rolls, [:subject_type, :subject_id]
  end
end
