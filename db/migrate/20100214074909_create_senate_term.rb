class CreateSenateTerm < ActiveRecord::Migration
  def self.up
    create_table :senate_terms do |t|
      t.integer :politician_id, :null => false
      t.date :started_on
      t.date :ended_on
      t.integer :party_id
      t.integer :senate_class, :null => false
      t.integer :us_state_id, :null => false
      t.string :url

      t.timestamps
    end
    constrain :senate_terms do |t|
      t.politician_id :reference => {:politicians => :id}
      t.party_id :reference => {:parties => :id}
      t.us_state_id :reference => {:us_states => :id}
    end
  end

  def self.down
  end
end
