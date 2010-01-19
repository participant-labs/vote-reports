class IndexStates < ActiveRecord::Migration
  def self.up
    add_index :us_states, :id, :unique => true
    add_index :us_states, :state_type
    add_index :us_states, :abbreviation, :unique => true
    add_index :us_states, :full_name, :unique => true
  end

  def self.down
    remove_index :us_states, :id
    remove_index :us_states, :state_type
    remove_index :us_states, :abbreviation
    remove_index :us_states, :full_name
  end
end
