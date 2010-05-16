class ContrainInterestGroupRatingsToUniquePairs < ActiveRecord::Migration
  def self.up
    remove_index "interest_group_ratings", :name => "index_interest_group_ratings_on_p_and_ig"
    add_index "interest_group_ratings", ["interest_group_report_id", "politician_id"], :unique => true, :name => "index_ig_ratings_on_p_and_ig"
  end

  def self.down
    raise "Nope"
  end
end
