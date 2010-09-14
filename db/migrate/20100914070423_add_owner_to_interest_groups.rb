class AddOwnerToInterestGroups < ActiveRecord::Migration
  def self.up
    add_column :interest_groups, :owner_id, :integer
    add_index :interest_groups, :owner_id
    add_foreign_key :interest_groups, :users, :column => :owner_id
  end

  def self.down
    remove_column :interest_groups, :owner_id
  end
end
