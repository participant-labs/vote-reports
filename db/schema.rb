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

ActiveRecord::Schema.define(:version => 20100117224654) do

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

  add_index "amendments", ["bill_id"], :name => "index_amendments_on_bill_id"
  add_index "amendments", ["congress_id"], :name => "index_amendments_on_congress_id"
  add_index "amendments", ["number", "chamber", "bill_id"], :name => "amendments_number_chamber_bill_id_unique", :unique => true
  add_index "amendments", ["number", "chamber", "congress_id"], :name => "amendments_number_chamber_congress_id_unique", :unique => true
  add_index "amendments", ["sequence", "bill_id"], :name => "amendments_sequence_bill_id_unique", :unique => true
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
    t.integer  "bill_id",    :null => false
    t.integer  "report_id",  :null => false
    t.boolean  "support",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
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

  add_index "bill_oppositions", ["bill_id"], :name => "index_bill_oppositions_on_bill_id"
  add_index "bill_oppositions", ["politician_id", "bill_id"], :name => "bill_oppositions_politician_id_bill_id_unique", :unique => true
  add_index "bill_oppositions", ["politician_id"], :name => "index_bill_oppositions_on_politician_id"

  create_table "bill_subjects", :force => true do |t|
    t.integer  "bill_id",    :null => false
    t.integer  "subject_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bill_subjects", ["bill_id", "subject_id"], :name => "bill_subjects_bill_id_subject_id_unique", :unique => true
  add_index "bill_subjects", ["bill_id"], :name => "index_bill_subjects_on_bill_id"
  add_index "bill_subjects", ["subject_id"], :name => "index_bill_subjects_on_subject_id"

  create_table "bill_supports", :force => true do |t|
    t.integer  "politician_id", :null => false
    t.integer  "bill_id",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bill_supports", ["bill_id"], :name => "index_bill_supports_on_bill_id"
  add_index "bill_supports", ["politician_id", "bill_id"], :name => "bill_supports_politician_id_bill_id_unique", :unique => true
  add_index "bill_supports", ["politician_id"], :name => "index_bill_supports_on_politician_id"

  create_table "bill_title_as", :force => true do |t|
    t.string   "as",         :null => false
    t.integer  "sort_order", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bill_title_as", ["as"], :name => "index_bill_title_as_on_as"

  create_table "bill_titles", :force => true do |t|
    t.text     "title",            :null => false
    t.string   "title_type",       :null => false
    t.integer  "bill_id",          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "bill_title_as_id", :null => false
  end

  add_index "bill_titles", ["bill_id"], :name => "index_bill_titles_on_bill_id"
  add_index "bill_titles", ["bill_title_as_id"], :name => "index_bill_titles_on_bill_title_as_id"

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

  add_index "bills", ["bill_type", "bill_number", "congress_id"], :name => "bills_bill_type_bill_number_congress_id_unique", :unique => true
  add_index "bills", ["congress_id"], :name => "index_bills_on_congress_id"
  add_index "bills", ["gov_track_id"], :name => "bills_gov_track_id_unique", :unique => true
  add_index "bills", ["gov_track_id"], :name => "index_bills_on_gov_track_id", :unique => true
  add_index "bills", ["opencongress_id"], :name => "bills_opencongress_id_unique", :unique => true
  add_index "bills", ["opencongress_id"], :name => "index_bills_on_opencongress_id", :unique => true
  add_index "bills", ["sponsor_id"], :name => "index_bills_on_sponsor_id"

  create_table "committee_meetings", :force => true do |t|
    t.string   "name",         :null => false
    t.integer  "congress_id",  :null => false
    t.integer  "committee_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "committee_meetings", ["committee_id"], :name => "index_committee_meetings_on_committee_id"
  add_index "committee_meetings", ["congress_id", "committee_id"], :name => "committee_meetings_congress_id_committee_id_unique", :unique => true
  add_index "committee_meetings", ["congress_id"], :name => "index_committee_meetings_on_congress_id"

  create_table "committee_memberships", :force => true do |t|
    t.integer  "politician_id",        :null => false
    t.integer  "committee_meeting_id", :null => false
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "committee_memberships", ["committee_meeting_id"], :name => "index_committee_memberships_on_committee_meeting_id"
  add_index "committee_memberships", ["politician_id", "committee_meeting_id"], :name => "committee_memberships_politician_id_committee_meeting_id_unique", :unique => true
  add_index "committee_memberships", ["politician_id"], :name => "index_committee_memberships_on_politician_id"

  create_table "committees", :force => true do |t|
    t.string   "chamber"
    t.string   "code",         :null => false
    t.string   "display_name", :null => false
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "committees", ["ancestry"], :name => "index_committees_on_ancestry"
  add_index "committees", ["code", "ancestry"], :name => "committees_code_ancestry_unique", :unique => true

  create_table "congresses", :force => true do |t|
    t.integer "meeting"
  end

  add_index "congresses", ["meeting"], :name => "congresses_meeting_unique", :unique => true

  create_table "cosponsorships", :force => true do |t|
    t.integer  "bill_id",       :null => false
    t.integer  "politician_id", :null => false
    t.date     "joined_on"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cosponsorships", ["bill_id", "politician_id"], :name => "cosponsorships_bill_id_politician_id_unique", :unique => true
  add_index "cosponsorships", ["bill_id"], :name => "index_cosponsorships_on_bill_id"
  add_index "cosponsorships", ["politician_id"], :name => "index_cosponsorships_on_politician_id"

  create_table "parties", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parties", ["name"], :name => "index_parties_on_name", :unique => true

  create_table "politician_terms", :force => true do |t|
    t.integer  "politician_id", :null => false
    t.date     "started_on"
    t.date     "ended_on"
    t.integer  "district"
    t.string   "state"
    t.string   "url"
    t.integer  "party_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "senate_class"
    t.string   "type",          :null => false
  end

  add_index "politician_terms", ["party_id"], :name => "index_politician_terms_on_party_id"
  add_index "politician_terms", ["politician_id"], :name => "index_politician_terms_on_politician_id"

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
    t.string   "cached_slug"
  end

  add_index "politicians", ["bioguide_id"], :name => "index_politicians_on_bioguide_id", :unique => true
  add_index "politicians", ["bioguide_id"], :name => "politicians_bioguide_id_unique", :unique => true
  add_index "politicians", ["congresspedia_url"], :name => "politicians_congresspedia_url_unique", :unique => true
  add_index "politicians", ["crp_id"], :name => "politicians_crp_id_unique", :unique => true
  add_index "politicians", ["email"], :name => "politicians_email_unique", :unique => true
  add_index "politicians", ["eventful_id"], :name => "politicians_eventful_id_unique", :unique => true
  add_index "politicians", ["fec_id"], :name => "index_politicians_on_fec_id", :unique => true
  add_index "politicians", ["fec_id"], :name => "politicians_fec_id_unique", :unique => true
  add_index "politicians", ["gov_track_id"], :name => "index_politicians_on_gov_track_id", :unique => true
  add_index "politicians", ["gov_track_id"], :name => "politicians_gov_track_id_unique", :unique => true
  add_index "politicians", ["metavid_id"], :name => "politicians_metavid_id_unique", :unique => true
  add_index "politicians", ["open_secrets_id"], :name => "politicians_open_secrets_id_unique", :unique => true
  add_index "politicians", ["phone"], :name => "politicians_phone_unique", :unique => true
  add_index "politicians", ["twitter_id"], :name => "politicians_twitter_id_unique", :unique => true
  add_index "politicians", ["vote_smart_id"], :name => "index_politicians_on_vote_smart_id", :unique => true
  add_index "politicians", ["vote_smart_id"], :name => "politicians_vote_smart_id_unique", :unique => true
  add_index "politicians", ["website"], :name => "politicians_website_unique", :unique => true
  add_index "politicians", ["youtube_url"], :name => "politicians_youtube_url_unique", :unique => true

  create_table "reports", :force => true do |t|
    t.integer  "user_id",     :null => false
    t.string   "name",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "cached_slug"
  end

  add_index "reports", ["user_id"], :name => "index_reports_on_user_id"

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

  add_index "rolls", ["congress_id"], :name => "index_rolls_on_congress_id"
  add_index "rolls", ["number", "year", "where"], :name => "rolls_number_year_where_unique", :unique => true
  add_index "rolls", ["roll_type"], :name => "index_rolls_on_roll_type"
  add_index "rolls", ["subject_id"], :name => "index_rolls_on_subject_id"
  add_index "rolls", ["subject_type", "subject_id"], :name => "index_rolls_on_subject_type_and_subject_id"
  add_index "rolls", ["subject_type"], :name => "index_rolls_on_subject_type"

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

  create_table "subjects", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "subjects", ["name"], :name => "index_subjects_on_name", :unique => true

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

  add_index "users", ["email"], :name => "users_email_unique", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true
  add_index "users", ["username"], :name => "users_username_unique", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "politician_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "roll_id"
    t.string   "vote"
  end

  add_index "votes", ["politician_id"], :name => "index_votes_on_politician_id"
  add_index "votes", ["roll_id", "politician_id"], :name => "index_votes_on_roll_id_and_politician_id", :unique => true
  add_index "votes", ["roll_id"], :name => "index_votes_on_roll_id"
  add_index "votes", ["vote"], :name => "index_votes_on_vote"

end
