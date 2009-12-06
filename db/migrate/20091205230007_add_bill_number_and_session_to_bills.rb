class AddBillNumberAndSessionToBills < ActiveRecord::Migration
  def self.up
    add_column :bills, :bill_number, :integer
    add_column :bills, :session, :integer
  end

  def self.down
    remove_column :bills, :session
    remove_column :bills, :bill_number

  end
end
