class MoreBillIndexes < ActiveRecord::Migration
  def self.up
    add_index :bill_title_as, :as, :unique => true
  end

  def self.down
    remove_index :bill_title_as, :as
  end
end
