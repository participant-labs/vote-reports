class CommitteesCanBeBasicallyEmpty < ActiveRecord::Migration
  def self.up
    change_column :committees, :code, :string, :null => true
    change_column :committees, :display_name, :string, :null => true
  end

  def self.down
    change_column :committees, :code, :string, :null => false
    change_column :committees, :display_name, :string, :null => false
  end
end
