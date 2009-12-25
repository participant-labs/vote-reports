# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20091225233538) do

  create_table "amendments", :force => true do |t|
    t.integer  "bill_id"
    t.string   "gov_track_id"
    t.text     "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "amendments", ["gov_track_id"], :name => "index_amendments_on_gov_track_id", :unique => true

  create_table "bill_criteria", :force => true do |t|
    t.integer  "bill_id"
    t.integer  "report_id"
    t.boolean  "support"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bill_criteria", ["bill_id", "report_id"], :name => "index_bill_criteria_on_bill_id_and_report_id", :unique => true

  create_table "bills", :force => true do |t|
    t.text     "title"
    t.string   "bill_type"
    t.string   "opencongress_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bill_number"
    t.string   "gov_track_id"
    t.integer  "congress_id"
    t.integer  "sponsor_id"
    t.date     "introduced_on"
    t.text     "summary"
  end

  add_index "bills", ["gov_track_id"], :name => "index_bills_on_gov_track_id", :unique => true
  add_index "bills", ["opencongress_id"], :name => "index_bills_on_opencongress_id", :unique => true

  create_table "congresses", :force => true do |t|
    t.integer "meeting"
  end

  create_table "politicians", :force => true do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "vote_smart_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "gov_track_id"
    t.string   "bioguide_id"
    t.string   "congress_office"
    t.string   "congresspedia_url"
    t.string   "crp_id"
    t.string   "district"
    t.string   "email"
    t.string   "eventful_id"
    t.string   "fax"
    t.string   "fec_id"
    t.string   "gender"
    t.string   "in_office"
    t.string   "middle_name"
    t.string   "name_suffix"
    t.string   "nickname"
    t.string   "party"
    t.string   "phone"
    t.string   "state"
    t.string   "title"
    t.string   "twitter_id"
    t.string   "webform"
    t.string   "website"
    t.string   "youtube_url"
    t.string   "metavid_id"
    t.date     "birthday"
    t.string   "religion"
    t.string   "official_rss"
    t.string   "open_secrets_id"
  end

  add_index "politicians", ["bioguide_id"], :name => "index_politicians_on_bioguide_id", :unique => true
  add_index "politicians", ["fec_id"], :name => "index_politicians_on_fec_id", :unique => true
  add_index "politicians", ["gov_track_id"], :name => "index_politicians_on_gov_track_id", :unique => true
  add_index "politicians", ["vote_smart_id"], :name => "index_politicians_on_vote_smart_id", :unique => true

  create_table "presidential_terms", :force => true do |t|
    t.integer  "politician_id"
    t.date     "started_on"
    t.date     "ended_on"
    t.string   "party"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", :force => true do |t|
    t.integer  "user_id"
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "cached_slug"
  end

  create_table "representative_terms", :force => true do |t|
    t.integer "politician_id"
    t.date    "started_on"
    t.date    "ended_on"
    t.integer "district"
    t.string  "party"
    t.string  "state"
    t.string  "url"
  end

  create_table "rolls", :force => true do |t|
    t.string   "where"
    t.datetime "voted_at"
    t.integer  "aye"
    t.integer  "nay"
    t.integer  "not_voting"
    t.integer  "present"
    t.string   "result"
    t.string   "required"
    t.text     "question"
    t.string   "roll_type"
    t.string   "gov_track_id"
    t.integer  "subject_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "congress_id"
    t.string   "subject_type"
  end

  add_index "rolls", ["gov_track_id"], :name => "index_rolls_on_opencongress_id", :unique => true

  create_table "senate_terms", :force => true do |t|
    t.integer "politician_id"
    t.date    "started_on"
    t.date    "ended_on"
    t.integer "senate_class"
    t.string  "party"
    t.string  "state"
    t.string  "url"
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
  end

  add_index "slugs", ["name", "scope", "sequence", "sluggable_type"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "persistence_token"
    t.string   "username"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "politician_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "roll_id"
    t.string   "vote"
  end

  add_index "votes", ["roll_id", "politician_id"], :name => "index_votes_on_roll_id_and_politician_id", :unique => true

  add_foreign_key "amendments", "bills", :name => "amendments_bill_id_fk", :dependent => :delete

  add_foreign_key "bill_criteria", "bills", :name => "bill_criteria_bill_id_fk", :dependent => :delete
  add_foreign_key "bill_criteria", "reports", :name => "bill_criteria_report_id_fk", :dependent => :delete

  add_foreign_key "bills", "congresses", :name => "bills_congress_id_fk", :dependent => :delete
  add_foreign_key "bills", "politicians", :name => "bills_sponsor_id_fk", :column => "sponsor_id", :dependent => :nullify

  add_foreign_key "presidential_terms", "politicians", :name => "presidential_terms_politician_id_fk", :dependent => :delete

  add_foreign_key "reports", "users", :name => "reports_user_id_fk", :dependent => :delete

  add_foreign_key "representative_terms", "politicians", :name => "representative_terms_politician_id_fk", :dependent => :delete

  add_foreign_key "rolls", "congresses", :name => "rolls_congress_id_fk", :dependent => :delete

  add_foreign_key "senate_terms", "politicians", :name => "senate_terms_politician_id_fk", :dependent => :delete

  add_foreign_key "votes", "politicians", :name => "votes_politician_id_fk", :dependent => :delete
  add_foreign_key "votes", "rolls", :name => "votes_roll_id_fk", :dependent => :delete

end
