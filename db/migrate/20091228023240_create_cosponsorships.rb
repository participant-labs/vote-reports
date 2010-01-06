class CreateCosponsorships < ActiveRecord::Migration
  def self.up
    transaction do
      create_table :cosponsorships do |t|
        t.integer :bill_id, :null => false
        t.integer :politician_id, :null => false
        t.date :joined_on, :null => false

        t.timestamps
      end
      constrain :cosponsorships do |t|
        t.bill_id :reference => {:bills => :id, :on_delete => :cascade}
        t.politician_id :reference => {:politicians => :id, :on_delete => :cascade}
      end
    end
  end

  def self.down
    drop_table :cosponsorships
  end
end
