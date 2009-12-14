class DropBillIdFromVoteAsItShouldBeOnRoll < ActiveRecord::Migration
  def self.up
    remove_column :votes, :bill_id
  end

  def self.down
    add_column :votes, :bill_id, :integer
  end
end
