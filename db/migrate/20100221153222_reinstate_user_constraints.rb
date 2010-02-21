class ReinstateUserConstraints < ActiveRecord::Migration
  def self.up
    remove_index :users, :username
    add_index :users, :username, :unique => true
    add_index :users, :email, :unique => true
    change_column :users, :email, :string, :null => false
    change_column :users, :username, :string, :null => false
  end

  def self.down
  end
end
