class AddCachedSlugToCauses < ActiveRecord::Migration
  def self.up
    add_column :causes, :cached_slug, :string
    `rake friendly_id:redo_slugs MODEL=Cause`
  end

  def self.down
    remove_column :causes, :cached_slug
  end
end
