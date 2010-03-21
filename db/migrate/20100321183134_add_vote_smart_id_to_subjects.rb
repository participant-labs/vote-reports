class AddVoteSmartIdToSubjects < ActiveRecord::Migration
  def self.up
    add_column :subjects, :vote_smart_id, :integer
    add_index :subjects, :vote_smart_id, :unique => true
  end

  def self.down
    remove_column :subjects, :vote_smart_id
    remove_index :subjects, :vote_smart_id
  end
end
