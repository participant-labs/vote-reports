class CreateIssues < ActiveRecord::Migration
  def self.up
    create_table :issues do |t|
      t.string :title, :null => false
      t.string :cached_slug

      t.timestamps
    end
    add_index :issues, :cached_slug
  end

  def self.down
    drop_table :issues
  end
end
