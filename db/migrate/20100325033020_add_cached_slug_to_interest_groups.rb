class AddCachedSlugToInterestGroups < ActiveRecord::Migration
  def self.up
    add_column :interest_groups, :cached_slug, :string
  end

  def self.down
    remove_column :interest_groups, :cached_slug
  end
end
