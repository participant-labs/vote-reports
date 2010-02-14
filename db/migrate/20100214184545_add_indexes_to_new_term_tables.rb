class AddIndexesToNewTermTables < ActiveRecord::Migration
  def self.up
    drop_table :politician_terms
    constrain :presidential_terms do |t|
      t.party_id :reference => {:parties => :id}
    end
    add_index :presidential_terms, :politician_id
    add_index :presidential_terms, :party_id
    add_index :senate_terms, :politician_id
    add_index :senate_terms, :party_id
    add_index :senate_terms, :us_state_id
    add_index :representative_terms, :politician_id
    add_index :representative_terms, :party_id
    add_index :representative_terms, :district_id
  end

  def self.down
  end
end
