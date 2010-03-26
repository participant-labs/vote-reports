class FixInterestGroupRatingForeignKeyConstraint < ActiveRecord::Migration
  def self.up
    deconstrain :interest_group_ratings, :interest_group_id, :reference
    constrain :interest_group_ratings, :interest_group_report_id, :reference => {:interest_group_reports => :id}
  end

  def self.down
    deconstrain :interest_group_ratings, :interest_group_report_id, :reference
    constrain :interest_group_ratings, :interest_group_report_id, :reference => {:interest_groups => :id}
  end
end
