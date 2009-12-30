class AddConstraintsToBillCriteria < ActiveRecord::Migration
  def self.up
    constrain :bill_criteria do |t|
      t.bill_id :reference => {:bills => :id, :on_delete => :cascade}, :not_null => true
      t.report_id :reference => {:reports => :id, :on_delete => :cascade}, :not_null => true
      t[:bill_id, :report_id].all :unique => true

      t.support :not_null => true
    end
  end

  def self.down
    deconstrain :bill_criteria do |t|
      t.bill_id :reference, :not_null
      t.report_id :reference , :not_null
      t[:bill_id, :report_id].all :unique

      t.support :not_null
    end
  end
end
