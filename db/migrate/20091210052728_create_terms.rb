class CreateTerms < ActiveRecord::Migration
  def self.up
   create_table :representative_terms do |t|
     t.references :politician
     t.references :congress
     t.date :started_on
     t.date :ended_on
     t.integer :district
     t.string :party
     t.string :state
     t.string :type
     t.string :url
   end

   create_table :senate_terms do |t|
     t.references :politician
     t.references :congress
     t.date :started_on
     t.date :ended_on
     t.integer :senate_class
     t.string :party
     t.string :state
     t.string :type
     t.string :url
   end
  end

  def self.down
    drop_table :senate_terms
    drop_table :representative_terms
  end
end
