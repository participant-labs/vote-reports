class DeleteAllVotesToClearTheWayForRollFocusedVotes < ActiveRecord::Migration
  def self.up
    Vote.delete_all
  end

  def self.down
  end
end
