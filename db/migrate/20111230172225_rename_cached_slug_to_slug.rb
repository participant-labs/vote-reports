class RenameCachedSlugToSlug < ActiveRecord::Migration
  def change
    [:causes, :interest_groups, :issues, :politicians, :reports, :subjects, :users].each do |table|
      rename_column table, :cached_slug, :slug
    end
  end
end
