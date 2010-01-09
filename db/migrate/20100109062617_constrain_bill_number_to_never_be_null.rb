class ConstrainBillNumberToNeverBeNull < ActiveRecord::Migration
  def self.up
    change_table :bills do |t|
      t.change :bill_number, :integer, :null => false
    end
  end

  def self.down
    change_table :bills do |t|
      t.change :bill_number, :integer, :null => true
    end
  end
end
