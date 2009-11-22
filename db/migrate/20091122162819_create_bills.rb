class CreateBills < ActiveRecord::Migration
  def self.up
    create_table :bills do |t|
      t.string :title
      t.string :bill_type
      t.string :opencongress_id

      t.timestamps
    end
  end

  def self.down
    drop_table :bills
  end
end
