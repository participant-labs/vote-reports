class ActivateAllUsers < ActiveRecord::Migration
  def self.up
    User.update_all(:state => 'active')
    change_column :users, :state, :string, :null => false
  end

  def self.down
    change_column :users, :state, :string, :null => true
  end
end
