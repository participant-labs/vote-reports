class CreateDistricts < ActiveRecord::Migration
  def self.up
    create_table :districts do |t|
      t.integer :us_state_id, :null => false
      t.integer :district, :null => false

      t.timestamps
    end
    constrain :districts do |t|
      t.us_state_id :reference => {:us_states => :id}
      t[:us_state_id, :district].all :unique => true
    end
  end

  def self.down
    drop_table :districts
  end
end
