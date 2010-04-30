class DropBillSupportsAndOppositions < ActiveRecord::Migration
  def self.up
    drop_table :bill_supports
    drop_table :bill_oppositions
  end

  def self.down
    create_table "bill_supports", :force => true do |t|
      t.integer  "politician_id", :null => false
      t.integer  "bill_id",       :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "bill_supports", ["bill_id", "politician_id"], :name => "index_bill_supports_on_bill_id_and_politician_id", :unique => true
    add_index "bill_supports", ["bill_id"], :name => "index_bill_supports_on_bill_id"
    add_index "bill_supports", ["politician_id"], :name => "index_bill_supports_on_politician_id"

    create_table "bill_oppositions", :force => true do |t|
      t.integer  "politician_id", :null => false
      t.integer  "bill_id",       :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
    end

    add_index "bill_oppositions", ["bill_id", "politician_id"], :name => "bill_oppositions_politician_id_bill_id_unique", :unique => true
    add_index "bill_oppositions", ["bill_id"], :name => "index_bill_oppositions_on_bill_id"
    add_index "bill_oppositions", ["politician_id"], :name => "index_bill_oppositions_on_politician_id"
  end
end
