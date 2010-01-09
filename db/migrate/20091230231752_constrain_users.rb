class ConstrainUsers < ActiveRecord::Migration
  def self.up
    change_table :users do |t|
      t.change :email, :string, :null => false
      t.change :username, :string, :null => false
    end

    constrain :users do |t|
      t.email :not_blank => true, :unique => true
      t.username :not_blank => true, :unique => true
    end
  end

  def self.down
    change_table :users do |t|
      t.change :email, :string, :null => true
      t.change :username, :string, :null => true
    end
  
    deconstrain :users do |t|
      t.email :not_null, :not_blank, :unique
      t.username :not_null, :not_blank, :unique
    end
  end
end
