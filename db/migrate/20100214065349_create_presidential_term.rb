class CreatePresidentialTerm < ActiveRecord::Migration
  def self.up
    create_table :presidential_terms do |t|
      t.integer :politician_id, :null => false
      t.date :started_on
      t.date :ended_on
      t.integer :party_id
      t.string :url

      t.timestamps
    end
    constrain :presidential_terms do |t|
      t.politician_id :reference => {:politicians => :id}
    end
  end

  def self.down
    drop_table :presidential_terms
  end
end
