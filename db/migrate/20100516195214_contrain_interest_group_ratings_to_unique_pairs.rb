class ContrainInterestGroupRatingsToUniquePairs < ActiveRecord::Migration
  def self.up
    dups = InterestGroupRating.all(:select => 'interest_group_report_id, politician_id, count(interest_group_ratings.id)', :group => 'interest_group_report_id, politician_id', :having => 'count(interest_group_ratings.id) > 1')
    if dups.map(&:politician_id).uniq != [602]
      raise "Unexpected politician dups #{dups.map(&:politician_id).inspect}"
    end

    dups = InterestGroupRating.all(:conditions => {:interest_group_report_id => dups.map(&:interest_group_report_id), :politician_id => 602})

    InterestGroupRating.update_all(
      {:politician_id => Politician.find_by_first_name_and_last_name('William', 'Jefferson')},
      {:id => dups.select {|dup| dup.description.include?('William Jefferson')}})

    remove_index "interest_group_ratings", :name => "index_interest_group_ratings_on_p_and_ig"
    add_index "interest_group_ratings", ["interest_group_report_id", "politician_id"], :unique => true, :name => "index_ig_ratings_on_p_and_ig"
  end

  def self.down
    raise "Nope"
  end
end
