class RemoveConstraintsFromUsers < ActiveRecord::Migration
  def self.up
    change_column :users, :email, :string, :null => true
    change_column :users, :username, :string, :null => true
  end

  def self.down
    change_column :users, :email, :string, :null => false
    change_column :users, :username, :string, :null => false
  end
end
