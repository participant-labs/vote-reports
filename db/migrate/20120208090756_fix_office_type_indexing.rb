class FixOfficeTypeIndexing < ActiveRecord::Migration
  def up
    remove_index "office_types", "vote_smart_id"
    add_index "office_types", ["branch_id", "level_id", "vote_smart_id"], unique: true
  end

  def down
    remove_index "office_types", ["branch_id", "level_id", "vote_smart_id"]
    add_index "office_types", "vote_smart_id", unique: true
  end
end
