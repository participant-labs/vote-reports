class ReportHasPolymorphicOwner < ActiveRecord::Migration
  def self.up
    add_column :reports, :interest_group_id, :integer
    change_column :reports, :user_id, :integer, :null => true
    constrain :reports, :interest_group_id, :reference => {:interest_groups => :id}
  end

  def self.down
    deconstrain :reports, :interest_group_id, :reference
    remove_column :reports, :interest_group_id, :integer
    change_column :reports, :user_id, :integer, :null => false
  end
end
