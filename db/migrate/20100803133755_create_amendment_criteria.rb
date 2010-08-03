class CreateAmendmentCriteria < ActiveRecord::Migration
  def self.up
    create_table "amendment_criteria", :force => true do |t|
      t.integer  "amendment_id",         :null => false
      t.integer  "report_id",       :null => false
      t.boolean  "support",         :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "explanatory_url"
    end

    add_index "amendment_criteria", ["amendment_id", "report_id"], :unique => true
    add_index "amendment_criteria", ["amendment_id"]
    add_index "amendment_criteria", ["report_id"]
    add_index "amendment_criteria", ["support"]

    add_foreign_key 'amendment_criteria', 'amendments'
  end

  def self.down
    drop_table 'amendment_criteria'
  end
end
