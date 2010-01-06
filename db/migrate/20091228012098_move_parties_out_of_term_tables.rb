class MovePartiesOutOfTermTables < ActiveRecord::Migration
  def self.up
    transaction do
      add_index :parties, :name, :unique => true
      constrain :parties do |t|
        t.name :blacklist => Party::BLACKLIST
      end
      [:senate_terms, :representative_terms, :presidential_terms].each do |table|
        add_column table, :party_id, :integer
        remove_column table, :party
        constrain table do |t|
          t.party_id :reference => {:parties => :id}
        end
      end
    end
  end

  def self.down
    raise "Irreversible (just a pain in the ass to do so, really)"
  end
end
