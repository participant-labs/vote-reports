class AddImageToInterestGroups < ActiveRecord::Migration
  def self.up
    add_column :interest_groups, :image_id, :integer
    constrain :interest_groups, :image_id, :reference => {:images => :id}
  end

  def self.down
    remove_column :interest_groups, :image_id
  end
end
