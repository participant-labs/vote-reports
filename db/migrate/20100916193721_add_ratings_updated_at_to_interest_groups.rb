class AddRatingsUpdatedAtToInterestGroups < ActiveRecord::Migration
  def self.up
    add_column :interest_groups, :ratings_updated_at, :datetime
  end

  def self.down
    remove_column :interest_groups, :ratings_updated_at, :datetime
  end
end
