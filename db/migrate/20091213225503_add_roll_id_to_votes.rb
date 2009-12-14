class AddRollIdToVotes < ActiveRecord::Migration
  def self.up
    add_column :votes, :roll_id, :integer
  end

  def self.down
    remove_column :votes, :roll_id
  end
end
