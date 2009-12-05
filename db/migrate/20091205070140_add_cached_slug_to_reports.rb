class AddCachedSlugToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :cached_slug, :string
  end

  def self.down
    remove_column :reports, :cached_slug
  end
end
