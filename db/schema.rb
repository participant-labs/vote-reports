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

ActiveRecord::Schema.define(:version => 20100201012831) do

  create_table "amendments", :force => true do |t|
    t.integer  "bill_id",      :null => false
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "number",       :null => false
    t.string   "chamber",      :null => false
    t.date     "offered_on",   :null => false
    t.integer  "sponsor_id",   :null => false
    t.string   "sponsor_type", :null => false
    t.text     "purpose"
    t.integer  "sequence"
    t.integer  "congress_id",  :null => false
  end

  add_index "amendments", ["bill_id", "chamber", "number"], :name => "amendments_number_bill_id_chamber_unique", :unique => true
  add_index "amendments", ["bill_id", "chamber", "number"], :name => "amendments_number_chamber_bill_id_unique", :unique => true
  add_index "amendments", ["bill_id", "sequence"], :name => "amendments_sequence_bill_id_unique", :unique => true
  add_index "amendments", ["bill_id"], :name => "index_amendments_on_bill_id"
  add_index "amendments", ["chamber", "congress_id", "number"], :name => "amendments_number_chamber_congress_id_unique", :unique => true
  add_index "amendments", ["congress_id"], :name => "index_amendments_on_congress_id"
  add_index "amendments", ["sponsor_id", "sponsor_type"], :name => "index_amendments_on_sponsor_id_and_sponsor_type"

  create_table "bill_committee_actions", :force => true do |t|
    t.string   "action",               :null => false
    t.integer  "committee_meeting_id", :null => false
    t.integer  "bill_id",              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bill_committee_actions", ["bill_id"], :name => "index_bill_committee_actions_on_bill_id"
  add_index "bill_committee_actions", ["committee_meeting_id"], :name => "index_bill_committee_actions_on_committee_meeting_id"

  create_table "bill_criteria", :force => true do |t|
    t.integer  "bill_id",         :null => false
    t.integer  "report_id",       :null => false
    t.boolean  "support",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "explanatory_url"
  end

  add_index "bill_criteria", ["bill_id", "report_id"], :name => "bill_criteria_bill_id_report_id_unique", :unique => true
  add_index "bill_criteria", ["bill_id", "report_id"], :name => "index_bill_criteria_on_bill_id_and_report_id", :unique => true
  add_index "bill_criteria", ["bill_id"], :name => "index_bill_criteria_on_bill_id"
  add_index "bill_criteria", ["support"], :name => "index_bill_criteria_on_support"

  create_table "bill_oppositions", :force => true do |t|
    t.integer  "politician_id", :null => false
    t.integer  "bill_id",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bill_oppositions", ["bill_id", "politician_id"], :name => "bill_oppositions_politician_id_bill_id_unique", :unique => true
  add_index "bill_oppositions", ["bill_id"], :name => "index_bill_oppositions_on_bill_id"
  add_index "bill_oppositions", ["politician_id"], :name => "index_bill_oppositions_on_politician_id"

  create_table "bill_subjects", :force => true do |t|
    t.integer  "bill_id",    :null => false
    t.integer  "subject_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bill_supports", :force => true do |t|
    t.integer  "politician_id", :null => false
    t.integer  "bill_id",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bill_title_as", :force => true do |t|
    t.string   "as",         :null => false
    t.integer  "sort_order", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "bill_titles", :force => true do |t|
    t.text     "title",            :null => false
    t.string   "title_type",       :null => false
    t.integer  "bill_id",          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bill_title_as_id", :null => false
  end

  create_table "bills", :force => true do |t|
    t.string   "bill_type",            :null => false
    t.string   "opencongress_id",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bill_number",          :null => false
    t.string   "gov_track_id",         :null => false
    t.integer  "congress_id",          :null => false
    t.integer  "sponsor_id"
    t.date     "introduced_on",        :null => false
    t.text     "summary"
    t.datetime "gov_track_updated_at"
  end

  create_table "committee_meetings", :force => true do |t|
    t.string   "name",         :null => false
    t.integer  "congress_id",  :null => false
    t.integer  "committee_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "committee_memberships", :force => true do |t|
    t.integer  "politician_id",        :null => false
    t.integer  "committee_meeting_id", :null => false
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "committees", :force => true do |t|
    t.string   "chamber"
    t.string   "code",         :null => false
    t.string   "display_name", :null => false
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "congresses", :force => true do |t|
    t.integer "meeting"
  end

  create_table "cosponsorships", :force => true do |t|
    t.integer  "bill_id",       :null => false
    t.integer  "politician_id", :null => false
    t.date     "joined_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "districts", :force => true do |t|
    t.integer  "us_state_id", :null => false
    t.integer  "district",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "districts", ["us_state_id", "district"], :name => "districts_us_state_id_district_unique", :unique => true

  create_table "parties", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "politician_terms", :force => true do |t|
    t.integer  "politician_id", :null => false
    t.date     "started_on",    :null => false
    t.date     "ended_on",      :null => false
    t.integer  "district"
    t.string   "url"
    t.integer  "party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "senate_class"
    t.string   "type",          :null => false
    t.integer  "us_state_id"
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
    t.string   "phone"
    t.string   "twitter_id"
    t.string   "webform"
    t.string   "website"
    t.string   "youtube_url"
    t.string   "metavid_id"
    t.date     "birthday"
    t.string   "religion"
    t.string   "official_rss"
    t.string   "open_secrets_id"
    t.string   "cached_slug"
    t.string   "title"
    t.integer  "us_state_id"
  end

  create_table "report_score_evidences", :force => true do |t|
    t.integer  "report_score_id",   :null => false
    t.integer  "vote_id",           :null => false
    t.integer  "bill_criterion_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "report_scores", :force => true do |t|
    t.integer  "politician_id", :null => false
    t.integer  "report_id",     :null => false
    t.float    "score",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "reports", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "name",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "cached_slug"
  end

  create_table "rolls", :force => true do |t|
    t.string   "where",        :null => false
    t.datetime "voted_at",     :null => false
    t.integer  "aye",          :null => false
    t.integer  "nay",          :null => false
    t.integer  "not_voting",   :null => false
    t.integer  "present",      :null => false
    t.string   "result",       :null => false
    t.string   "required",     :null => false
    t.text     "question",     :null => false
    t.string   "roll_type",    :null => false
    t.integer  "subject_id",   :null => false
    t.integer  "congress_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "subject_type", :null => false
    t.integer  "year",         :null => false
    t.integer  "number",       :null => false
  end

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
  end

  create_table "subjects", :force => true do |t|
    t.string "name", :null => false
  end

  create_table "us_states", :force => true do |t|
    t.string   "abbreviation", :limit => 2, :null => false
    t.string   "full_name",                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state_type",                :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",             :null => false
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "persistence_token"
    t.string   "username",          :null => false
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
