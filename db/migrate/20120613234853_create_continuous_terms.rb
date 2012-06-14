class CreateContinuousTerms < ActiveRecord::Migration
  def change
    create_table :continuous_terms do |t|
      t.integer :politician_id, null: false
      t.date :started_on, null: false
      t.date :ended_on, null: false

      t.integer :example_term_id, null: false
      t.string :example_term_type, null: false
      t.integer :terms_count, null: false
    end
    add_index :continuous_terms, :politician_id
    add_foreign_key :continuous_terms, :politicians
  end
end
