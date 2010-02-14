class CreateRepresentativeTerm < ActiveRecord::Migration
  def self.up
    create_table :representative_terms do |t|
      t.integer :politician_id, :null => false
      t.date :started_on
      t.date :ended_on
      t.integer :party_id
      t.integer :district_id, :null => false
      t.string :url

      t.timestamps
    end
    constrain :representative_terms do |t|
      t.politician_id :reference => {:politicians => :id}
      t.party_id :reference => {:parties => :id}
      t.district_id :reference => {:districts => :id}
    end
  end

  def self.down
  end
end
