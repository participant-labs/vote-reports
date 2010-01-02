class CreateBillSubjects < ActiveRecord::Migration
  def self.up
    transaction do
      create_table :bill_subjects do |t|
        t.integer :bill_id, :null => false
        t.integer :term_id, :null => false

        t.timestamps
      end
      constrain :bill_subjects do |t|
        t.bill_id :reference => {:bills => :id, :on_delete => :cascade}
        t.term_id :reference => {:terms => :id, :on_delete => :cascade}
      end
    end
  end

  def self.down
    drop_table :bill_subjects
  end
end
