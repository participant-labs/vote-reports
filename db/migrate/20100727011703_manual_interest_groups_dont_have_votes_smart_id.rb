class ManualInterestGroupsDontHaveVotesSmartId < ActiveRecord::Migration
  def self.up
    change_column :interest_groups, :vote_smart_id, :integer, :null => true
  end

  def self.down
    change_column :interest_groups, :vote_smart_id, :integer, :null => false
  end
end
