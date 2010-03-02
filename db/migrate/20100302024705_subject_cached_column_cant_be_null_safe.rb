class SubjectCachedColumnCantBeNullSafe < ActiveRecord::Migration
  def self.up
    change_column :subjects, :cached_slug, :string, :null => true
  end

  def self.down
    change_column :subjects, :cached_slug, :string, :null => false
  end
end
