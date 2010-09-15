class AddCandidacyModels < ActiveRecord::Migration
  def self.up
    change_column_null :politicians, :gov_track_id, true # we'll now have some votesmart-only pols

    create_table "elections", :force => true do |t|
      t.string "name"
      t.text "description"
      t.datetime "created_at"
      t.datetime "updated_at"
      t.integer "vote_smart_id", :null => false
      t.integer "state_id"
      t.integer "year"
      t.boolean "special"
      t.string "office_type"
    end
    add_foreign_key :elections, :us_states, :column => :state_id
    add_index :elections, :vote_smart_id, :unique => true

    create_table "election_stages" do |t|
      t.string "name", :null => false
      t.integer :election_id, :null => false
      t.string :vote_smart_id, :null => false
      t.date :voted_on, :null => false
    end
    add_foreign_key :election_stages, :elections
    add_index :election_stages, [:election_id, :vote_smart_id], :unique => true

    create_table :office_types do |t|
      t.string 'name', :null => false
      t.string 'level_id', :null => false
      t.string :branch_id, :null => false
      t.string :vote_smart_id, :null => false
    end
    add_index :office_types, :vote_smart_id, :unique => true

    create_table "offices", :force => true do |t|
      t.string "name", :null => false
      t.string "title"
      t.string "short_title"
      t.integer :office_type_id, :null => false
      t.string 'level_id', :null => false
      t.string :branch_id, :null => false
      t.integer :vote_smart_id, :null => false
    end
    add_foreign_key :offices, :office_types
    add_index :offices, :vote_smart_id, :unique => true

    create_table "races", :force => true do |t|
      t.string "district"
      t.integer "election_stage_id", :null => false
      t.integer "office_id", :null => false
    end
    add_foreign_key :races, :election_stages
    add_foreign_key :races, :offices

    create_table "candidacies", :force => true do |t|
      t.integer "politician_id", :null => false
      t.string "party"
      t.integer "race_id", :null => false
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string "status"
      t.string "office"
      t.integer "vote_count"
      t.float "vote_percent"
    end
    add_foreign_key :candidacies, :politicians
    add_foreign_key :candidacies, :races
  end

  def self.down
    drop_table :candidacies
    drop_table :races
    drop_table :election_stages
    drop_table :elections
    drop_table :offices
    drop_table :office_types
  end
end
