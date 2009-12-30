class ConstrainUsers < ActiveRecord::Migration
  def self.up
    constrain :users do |t|
      t.email :not_null => true, :not_blank => true, :unique => true
      t.username :not_null => true, :not_blank => true, :unique => true
    end
  end

  def self.down
    deconstrain :users do |t|
      t.email :not_null, :not_blank, :unique
      t.username :not_null, :not_blank, :unique
    end
  end
end
