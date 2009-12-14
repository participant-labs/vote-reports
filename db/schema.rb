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

ActiveRecord::Schema.define(:version => 20091214023624) do

  create_table "amendments", :force => true do |t|
    t.integer  "bill_id"
    t.string   "gov_track_id"
    t.text     "title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bill_criteria", :force => true do |t|
    t.integer  "bill_id"
    t.integer  "report_id"
    t.boolean  "support"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

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
    t.string   "middlename"
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
    t.integer "congress_id"
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
    t.string   "opencongress_id"
    t.integer  "bill_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "title"
    t.integer  "congress_id"
  end

  create_table "senate_terms", :force => true do |t|
    t.integer "politician_id"
    t.integer "congress_id"
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

  create_table "votes", :force => true do |t|
    t.integer  "politician_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "roll_id"
    t.string   "vote"
  end

end
