class RenameSlugsToFriendlyIdSlugs < ActiveRecord::Migration
  def up
    rename_table :slugs, :friendly_id_slugs
    rename_column :friendly_id_slugs, :name, :slug
  end

  def down
    rename_column :friendly_id_slugs, :slug, :name
    rename_table :friendly_id_slugs, :slugs
  end
end
