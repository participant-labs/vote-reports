class AddIndexesForCachedSlugs < ActiveRecord::Migration
  def self.up
    add_index :interest_groups, :cached_slug
    add_index :politicians, :cached_slug
    add_index :reports, :cached_slug
    add_index :subjects, :cached_slug
    add_index :users, :cached_slug
  end

  def self.down
    raise 'nope'
  end
end
