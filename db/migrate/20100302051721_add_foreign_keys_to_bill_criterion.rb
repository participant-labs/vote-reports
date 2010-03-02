class AddForeignKeysToBillCriterion < ActiveRecord::Migration
  def self.up
    constrain :bill_criteria do |t|
      t.bill_id :reference => {:bills => :id, :on_delete => :cascade}
      t.report_id :reference => {:reports => :id, :on_delete => :cascade}
    end
  end

  def self.down
    deconstrain :bill_criteria do |t|
      t.bill_id :reference
      t.report_id :reference
    end
  end
end
