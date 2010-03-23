class TransferInterestGroupRatingToIgReport < ActiveRecord::Migration
  def self.up
    remove_column :interest_group_ratings, :time_span
    remove_column :interest_group_ratings, :vote_smart_id
    rename_column :interest_group_ratings, :interest_group_id, :interest_group_report_id
    change_column :interest_group_ratings, :description, :text, :null => false

    remove_index "interest_group_reports", ["interest_group_id", "timespan"]
  end

  def self.down
    add_index "interest_group_reports", ["interest_group_id", "timespan"], :unique => true

    add_column :interest_group_ratings, :time_span, :string
    add_column :interest_group_ratings, :vote_smart_id, :integer
    rename_column :interest_group_ratings, :interest_group_report_id, :interest_group_id
    change_column :interest_group_ratings, :description, :string, :null => false
  end
end
