class CreateBillCriteria < ActiveRecord::Migration
  def self.up
    create_table :bill_criteria do |t|
      t.references :bill
      t.references :report
      t.boolean :support
      t.timestamps
    end
  end

  def self.down
    drop_table :bill_criteria
  end
end
