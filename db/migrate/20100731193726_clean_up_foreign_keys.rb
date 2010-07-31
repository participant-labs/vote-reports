class CleanUpForeignKeys < ActiveRecord::Migration
  def self.up
    remove_foreign_key 'districts', :name => 'districts_us_state_id_reference'
    remove_foreign_key 'congressional_districts', :name => 'districts_us_state_id_reference'
    add_foreign_key "congressional_districts", "us_states"
    add_foreign_key "districts", "us_states"
  end

  def self.down
    add_foreign_key "congressional_districts", "us_states"
    add_foreign_key "districts", "us_states"
  end
end
