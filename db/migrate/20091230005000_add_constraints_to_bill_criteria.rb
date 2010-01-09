class AddConstraintsToBillCriteria < ActiveRecord::Migration
  def self.up
    change_table :bill_criteria do |t|
      t.change :bill_id, :integer, :null => false
      t.change :report_id, :integer, :null => false
      t.change :support, :boolean, :null => false
    end

    constrain :bill_criteria do |t|
      t.bill_id :reference => {:bills => :id, :on_delete => :cascade}
      t.report_id :reference => {:reports => :id, :on_delete => :cascade}
      t[:bill_id, :report_id].all :unique => true
    end
  end

  def self.down
    change_table :bill_criteria do |t|
      t.change :bill_id, :integer, :null => true
      t.change :report_id, :integer, :null => true
      t.change :support, :boolean, :null => true
    end

    deconstrain :bill_criteria do |t|
      t.bill_id :reference
      t.report_id :reference
      t[:bill_id, :report_id].all :unique
    end
  end
end
