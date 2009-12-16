class AddIndexesToRollsVotesEtc < ActiveRecord::Migration
  def self.up
    add_index :amendments, :gov_track_id, :unique => true
    add_index :bills, :gov_track_id, :unique => true
    add_index :bills, :opencongress_id, :unique => true
    add_index :bill_criteria, [:bill_id, :report_id], :unique => true
    add_index :rolls, :opencongress_id, :unique => true
    add_index :users, :username, :unique => true
    add_index :votes, [:roll_id, :politician_id], :unique => true
    add_index :politicians, :gov_track_id, :unique => true
    add_index :politicians, :vote_smart_id, :unique => true
    add_index :politicians, :bioguide_id, :unique => true
    add_index :politicians, :fec_id, :unique => true
  end

  def self.down
    remove_index :amendments, :gov_track_id, :unique => true
    remove_index :bills, :gov_track_id, :unique => true
    remove_index :bills, :opencongress_id, :unique => true
    remove_index :bill_criteria, [:bill_id, :report_id], :unique => true
    remove_index :rolls, :opencongress_id, :unique => true
    remove_index :users, :username, :unique => true
    remove_index :votes, [:roll_id, :politician_id], :unique => true
    remove_index :politicians, :gov_track_id, :unique => true
    remove_index :politicians, :vote_smart_id, :unique => true
    remove_index :politicians, :bioguide_id, :unique => true
    remove_index :politicians, :fec_id, :unique => true
  end
end
