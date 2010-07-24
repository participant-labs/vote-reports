class MoreWilliamJeffersonRatings < ActiveRecord::Migration
  def self.up
    ratings = InterestGroupRating.all(:conditions => {:politician_id => 602}).select {|r| r.description.include?('William Jefferson') }
    InterestGroupRating.update_all(
      {:politician_id => Politician.find_by_first_name_and_last_name('William', 'Jefferson')},
      {:id => ratings})
    ratings.each {|r| r.interest_group_report.interest_group.report.rescore! }
  end

  def self.down
    raise 'nope'
  end
end
