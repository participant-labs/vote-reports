class CreateBillOppositions < ActiveRecord::Migration
  def self.up
    create_table :bill_oppositions do |t|
      t.integer :politician_id, :null => false
      t.integer :bill_id, :null => false

      t.timestamps
    end
    constrain :bill_oppositions do |t|
      t.politician_id :reference => {:politicians => :id}
      t.bill_id :reference => {:bills => :id}
      t[:politician_id, :bill_id].all :unique => true
    end
    add_index :bill_oppositions, :politician_id
    add_index :bill_oppositions, :bill_id
  end

  def self.down
    drop_table :bill_oppositions
  end
end
