class AddSlugCacheToPoliticians < ActiveRecord::Migration
  def self.up
    add_column :politicians, :cached_slug, :string
  end

  def self.down
    remove_column :politicians, :cached_slug, :string
  end
end
