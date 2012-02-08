class FixElectionStageIndexing < ActiveRecord::Migration
  def up
    remove_index "election_stages", ["election_id", "vote_smart_id"]
    add_index "election_stages", ["election_id", "vote_smart_id", "voted_on"], :unique => true, :name => 'index_election_stages'
  end

  def down
    remove_index "election_stages", ["election_id", "vote_smart_id", "voted_on"]
    add_index "election_stages", ["election_id", "vote_smart_id"], :unique => true
  end
end
