class AddAuthlogicMagicColumnsToUser < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.integer :login_count, :default => 0, :null => false
      t.integer :failed_login_count, :default => 0, :null => false
      t.datetime :last_request_at
      t.datetime :last_login_at
      t.datetime :current_login_at
      t.string :last_login_ip
      t.string :current_login_ip
    end

    add_index :users, :username
    add_index :users, :persistence_token
    add_index :users, :last_request_at
  end

  def self.down
    remove_columns :users, :login_count, :failed_login_count, :last_request_at, :last_login_at, :current_login_at, :last_login_ip, :current_login_ip

    remove_index :users, :username
    remove_index :users, :persistence_token
    remove_index :users, :last_request_at
  end
end
