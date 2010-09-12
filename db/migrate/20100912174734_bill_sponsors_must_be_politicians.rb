class BillSponsorsMustBePoliticians < ActiveRecord::Migration
  def self.up
    add_foreign_key :bills, :politicians, :column => :sponsor_id
  end

  def self.down
    remove_foreign_key :bills, :politicians, :column => :sponsor_id
  end
end
