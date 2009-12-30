class CreatePresidentialTerms < ActiveRecord::Migration
  def self.up
    transaction do
      create_table :presidential_terms do |t|
        t.integer :politician_id
        t.date :started_on
        t.date :ended_on
        t.string :party
        t.string :url

        t.timestamps
      end
    end
  end

  def self.down
    drop_table :presidential_terms
  end
end
