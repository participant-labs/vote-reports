class DropSenateAndPresidentialTermTables < ActiveRecord::Migration
  def self.up
    drop_table :senate_terms
    drop_table :presidential_terms
  end

  def self.down
  end
end
