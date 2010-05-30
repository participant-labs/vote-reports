class AddCachedSlugToCauses < ActiveRecord::Migration
  def self.up
    add_column :causes, :cached_slug, :string
    ENV['MODEL'] = 'Cause'
    Rake::Task['friendly_id:redo_slugs'].invoke
  end

  def self.down
    remove_column :causes, :cached_slug
  end
end
