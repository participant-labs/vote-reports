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

ActiveRecord::Schema.define(:version => 20100321230526) do

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

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "district_zip_codes", :force => true do |t|
    t.integer  "district_id", :null => false
    t.integer  "zip_code",    :null => false
    t.integer  "plus_4"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "district_zip_codes", ["district_id", "zip_code", "plus_4"], :name => "district_zip_codes_district_id_zip_code_plus_4_unique", :unique => true
  add_index "district_zip_codes", ["district_id"], :name => "index_district_zip_codes_on_district_id"
  add_index "district_zip_codes", ["zip_code", "plus_4"], :name => "index_district_zip_codes_on_zip_code_and_plus_4"
  add_index "district_zip_codes", ["zip_code"], :name => "index_district_zip_codes_on_zip_code"

  create_table "districts", :force => true do |t|
    t.integer  "us_state_id", :null => false
    t.integer  "district"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "districts", ["us_state_id", "district"], :name => "districts_us_state_id_district_unique", :unique => true
  add_index "districts", ["us_state_id"], :name => "index_districts_on_us_state_id"

  create_table "interest_group_ratings", :force => true do |t|
    t.integer  "interest_group_id", :null => false
    t.integer  "politician_id",     :null => false
    t.string   "vote_smart_id",     :null => false
    t.string   "rating",            :null => false
    t.string   "description",       :null => false
    t.string   "time_span",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interest_group_ratings", ["interest_group_id", "politician_id"], :name => "index_interest_group_ratings_on_p_and_ig"
  add_index "interest_group_ratings", ["interest_group_id"], :name => "index_interest_group_ratings_on_interest_group_id"
  add_index "interest_group_ratings", ["politician_id"], :name => "index_interest_group_ratings_on_politician_id"

  create_table "interest_groups", :force => true do |t|
    t.integer  "vote_smart_id", :null => false
    t.string   "ancestry"
    t.string   "name",          :null => false
    t.text     "description"
    t.string   "email"
    t.string   "url"
    t.string   "contact_name"
    t.string   "phone1"
    t.string   "phone2"
    t.string   "fax"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "zip"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interest_groups", ["ancestry"], :name => "index_interest_groups_on_ancestry"
  add_index "interest_groups", ["vote_smart_id"], :name => "index_interest_groups_on_vote_smart_id", :unique => true

  create_table "parties", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string   "email"
    t.string   "eventful_id"
    t.string   "fax"
    t.string   "fec_id"
    t.string   "gender"
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
    t.integer  "district"
  end

  create_table "presidential_terms", :force => true do |t|
    t.integer  "politician_id", :null => false
    t.date     "started_on"
    t.date     "ended_on"
    t.integer  "party_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "presidential_terms", ["party_id"], :name => "index_presidential_terms_on_party_id"
  add_index "presidential_terms", ["politician_id"], :name => "index_presidential_terms_on_politician_id"

  create_table "report_delayed_jobs", :force => true do |t|
    t.integer "report_id",      :null => false
    t.integer "delayed_job_id", :null => false
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
    t.integer  "user_id",                :null => false
    t.string   "name",                   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "cached_slug"
    t.string   "state"
    t.string   "thumbnail_file_name"
    t.string   "thumbnail_content_type"
    t.string   "thumbnail_file_size"
  end

  create_table "representative_terms", :force => true do |t|
    t.integer  "politician_id", :null => false
    t.date     "started_on"
    t.date     "ended_on"
    t.integer  "party_id"
    t.integer  "district_id",   :null => false
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "representative_terms", ["district_id"], :name => "index_representative_terms_on_district_id"
  add_index "representative_terms", ["party_id"], :name => "index_representative_terms_on_party_id"
  add_index "representative_terms", ["politician_id"], :name => "index_representative_terms_on_politician_id"

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
    t.string   "friendly_id"
  end

  create_table "rpx_identifiers", :force => true do |t|
    t.string   "identifier",    :null => false
    t.string   "provider_name"
    t.integer  "user_id",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rpx_identifiers", ["identifier"], :name => "index_rpx_identifiers_on_identifier", :unique => true
  add_index "rpx_identifiers", ["user_id"], :name => "index_rpx_identifiers_on_user_id"

  create_table "senate_terms", :force => true do |t|
    t.integer  "politician_id", :null => false
    t.date     "started_on"
    t.date     "ended_on"
    t.integer  "party_id"
    t.integer  "senate_class",  :null => false
    t.integer  "us_state_id",   :null => false
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "senate_terms", ["party_id"], :name => "index_senate_terms_on_party_id"
  add_index "senate_terms", ["politician_id"], :name => "index_senate_terms_on_politician_id"
  add_index "senate_terms", ["us_state_id"], :name => "index_senate_terms_on_us_state_id"

  create_table "slugs", :force => true do |t|
    t.string   "name"
    t.integer  "sluggable_id"
    t.integer  "sequence",                     :default => 1, :null => false
    t.string   "sluggable_type", :limit => 40
    t.string   "scope",          :limit => 40
    t.datetime "created_at"
  end

  create_table "subjects", :force => true do |t|
    t.string  "name",          :null => false
    t.string  "cached_slug"
    t.integer "vote_smart_id"
  end

  add_index "subjects", ["vote_smart_id"], :name => "index_subjects_on_vote_smart_id", :unique => true

  create_table "us_states", :force => true do |t|
    t.string   "abbreviation", :limit => 2, :null => false
    t.string   "full_name",                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state_type",                :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email",                             :null => false
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "persistence_token"
    t.string   "username",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
    t.string   "state",                             :null => false
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["last_request_at"], :name => "index_users_on_last_request_at"
  add_index "users", ["persistence_token"], :name => "index_users_on_persistence_token"
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "politician_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "roll_id"
    t.string   "vote"
  end

end
