class CreateBillTitleAs < ActiveRecord::Migration
  def self.up
    create_table :bill_title_as do |t|
      t.string :as, :null => false
      t.integer :sort_order, :null => false

      t.timestamps
    end
    constrain :bill_title_as do |t|
      t.as :whitelist => ["reported to senate", "agreed to by house and senate", "amended by house",
        "passed senate", "amended by senate", "introduced", "enacted", "reported to house", "passed house"]
    end
  end

  def self.down
    drop_table :bill_title_as
  end
end
