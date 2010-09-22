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

ActiveRecord::Schema.define(:version => 20100922022754) do

  create_table "adminships", :force => true do |t|
    t.integer  "user_id",       :null => false
    t.integer  "created_by_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "adminships", ["created_by_id"], :name => "index_adminships_on_created_by_id"
  add_index "adminships", ["user_id"], :name => "index_adminships_on_user_id", :unique => true

  create_table "amendment_criteria", :force => true do |t|
    t.integer  "amendment_id",    :null => false
    t.integer  "report_id",       :null => false
    t.boolean  "support",         :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "explanatory_url"
  end

  add_index "amendment_criteria", ["amendment_id", "report_id"], :name => "index_amendment_criteria_on_amendment_id_and_report_id", :unique => true
  add_index "amendment_criteria", ["amendment_id"], :name => "index_amendment_criteria_on_amendment_id"
  add_index "amendment_criteria", ["report_id"], :name => "index_amendment_criteria_on_report_id"
  add_index "amendment_criteria", ["support"], :name => "index_amendment_criteria_on_support"

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
    t.string   "short_name",   :null => false
  end

  add_index "amendments", ["bill_id", "chamber", "number"], :name => "amendments_number_bill_id_chamber_unique", :unique => true
  add_index "amendments", ["bill_id", "chamber", "number"], :name => "amendments_number_chamber_bill_id_unique", :unique => true
  add_index "amendments", ["bill_id", "sequence"], :name => "amendments_sequence_bill_id_unique", :unique => true
  add_index "amendments", ["bill_id"], :name => "index_amendments_on_bill_id"
  add_index "amendments", ["chamber", "congress_id", "number"], :name => "amendments_number_chamber_congress_id_unique", :unique => true
  add_index "amendments", ["congress_id"], :name => "index_amendments_on_congress_id"
  add_index "amendments", ["short_name", "bill_id"], :name => "index_amendments_on_short_name_and_bill_id", :unique => true
  add_index "amendments", ["short_name"], :name => "index_amendments_on_short_name"
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
  add_index "bill_criteria", ["report_id"], :name => "index_bill_criteria_on_report_id"
  add_index "bill_criteria", ["support"], :name => "index_bill_criteria_on_support"

  create_table "bill_subjects", :force => true do |t|
    t.integer  "bill_id",    :null => false
    t.integer  "subject_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bill_subjects", ["bill_id", "subject_id"], :name => "index_bill_subjects_on_bill_id_and_subject_id", :unique => true
  add_index "bill_subjects", ["bill_id"], :name => "index_bill_subjects_on_bill_id"
  add_index "bill_subjects", ["subject_id"], :name => "index_bill_subjects_on_subject_id"

  create_table "bill_title_as", :force => true do |t|
    t.string   "as",         :null => false
    t.integer  "sort_order", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bill_title_as", ["as"], :name => "index_bill_title_as_on_as", :unique => true

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
    t.date     "introduced_on",        :null => false
    t.text     "summary"
    t.datetime "gov_track_updated_at"
    t.integer  "sponsorship_id"
  end

  add_index "bills", ["congress_id", "bill_type", "bill_number"], :name => "index_bills_on_congress_id_and_bill_type_and_bill_number", :unique => true
  add_index "bills", ["congress_id"], :name => "index_bills_on_congress_id"
  add_index "bills", ["gov_track_id"], :name => "index_bills_on_gov_track_id", :unique => true
  add_index "bills", ["opencongress_id"], :name => "index_bills_on_opencongress_id", :unique => true
  add_index "bills", ["sponsorship_id"], :name => "index_bills_on_sponsorship_id", :unique => true

  create_table "candidacies", :force => true do |t|
    t.integer  "politician_id", :null => false
    t.string   "party"
    t.integer  "race_id",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "status"
    t.string   "office"
    t.integer  "vote_count"
    t.float    "vote_percent"
  end

  create_table "cause_reports", :force => true do |t|
    t.integer  "report_id",  :null => false
    t.integer  "cause_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "causes", :force => true do |t|
    t.string   "name",        :null => false
    t.text     "description", :null => false
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
  end

  add_index "causes", ["cached_slug"], :name => "index_causes_on_cached_slug"

  create_table "committee_meetings", :force => true do |t|
    t.string   "name"
    t.integer  "congress_id",  :null => false
    t.integer  "committee_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "committee_meetings", ["committee_id"], :name => "index_committee_meetings_on_committee_id"
  add_index "committee_meetings", ["congress_id", "committee_id"], :name => "index_committee_meetings_on_congress_id_and_committee_id", :unique => true
  add_index "committee_meetings", ["congress_id"], :name => "index_committee_meetings_on_congress_id"

  create_table "committee_memberships", :force => true do |t|
    t.integer  "politician_id",        :null => false
    t.integer  "committee_meeting_id", :null => false
    t.string   "role"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "committee_memberships", ["committee_meeting_id"], :name => "index_committee_memberships_on_committee_meeting_id"
  add_index "committee_memberships", ["politician_id", "committee_meeting_id"], :name => "index_committee_memberships_on_pol_id_and_com_meeting_id", :unique => true
  add_index "committee_memberships", ["politician_id"], :name => "index_committee_memberships_on_politician_id"

  create_table "committees", :force => true do |t|
    t.string   "chamber"
    t.string   "code"
    t.string   "display_name"
    t.string   "ancestry"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "committees", ["code", "ancestry"], :name => "index_committees_on_code_and_ancestry", :unique => true

  create_table "congresses", :force => true do |t|
    t.integer "meeting"
  end

  add_index "congresses", ["meeting"], :name => "index_congresses_on_meeting", :unique => true

  create_table "congressional_district_zip_codes", :force => true do |t|
    t.integer  "congressional_district_id", :null => false
    t.integer  "zip_code_id",               :null => false
    t.integer  "plus_4"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "congressional_district_zip_codes", ["congressional_district_id", "zip_code_id", "plus_4"], :name => "district_zip_codes_district_id_zip_code_plus_4_unique", :unique => true
  add_index "congressional_district_zip_codes", ["congressional_district_id"], :name => "index_district_zip_codes_on_district_id"
  add_index "congressional_district_zip_codes", ["zip_code_id", "plus_4"], :name => "index_district_zip_codes_on_zip_code_and_plus_4"
  add_index "congressional_district_zip_codes", ["zip_code_id"], :name => "index_district_zip_codes_on_zip_code"

  create_table "congressional_districts", :force => true do |t|
    t.integer  "us_state_id", :null => false
    t.integer  "district"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "congressional_districts", ["us_state_id", "district"], :name => "districts_us_state_id_district_unique", :unique => true

  create_table "cosponsorships", :force => true do |t|
    t.integer  "bill_id",       :null => false
    t.integer  "politician_id", :null => false
    t.date     "joined_on",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "cosponsorships", ["bill_id", "politician_id"], :name => "index_cosponsorships_on_bill_id_and_politician_id", :unique => true
  add_index "cosponsorships", ["bill_id"], :name => "index_cosponsorships_on_bill_id"
  add_index "cosponsorships", ["politician_id"], :name => "index_cosponsorships_on_politician_id"

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

  add_index "delayed_jobs", ["priority", "run_at"], :name => "index_delayed_jobs_on_priority_and_run_at"

  create_table "districts", :force => true do |t|
    t.string        "cd",            :limit => 3
    t.string        "lsad",          :limit => 2
    t.string        "name",          :limit => 90
    t.string        "lsad_trans",    :limit => 50
    t.multi_polygon "the_geom",      :limit => nil, :null => false
    t.string        "level"
    t.string        "census_geo_id"
    t.integer       "us_state_id",                  :null => false
  end

  add_index "districts", ["the_geom"], :name => "index_districts_on_the_geom", :spatial => true
  add_index "districts", ["us_state_id"], :name => "index_districts_on_us_state_id"

  create_table "election_stages", :force => true do |t|
    t.string  "name",          :null => false
    t.integer "election_id",   :null => false
    t.string  "vote_smart_id", :null => false
    t.date    "voted_on",      :null => false
  end

  add_index "election_stages", ["election_id", "vote_smart_id"], :name => "index_election_stages_on_election_id_and_vote_smart_id", :unique => true

  create_table "elections", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "vote_smart_id", :null => false
    t.integer  "state_id"
    t.integer  "year"
    t.boolean  "special"
    t.string   "office_type"
  end

  add_index "elections", ["vote_smart_id"], :name => "index_elections_on_vote_smart_id", :unique => true

  create_table "guide_reports", :force => true do |t|
    t.integer  "guide_id",   :null => false
    t.integer  "report_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "guide_reports", ["guide_id", "report_id"], :name => "index_guide_reports_on_guide_id_and_report_id", :unique => true
  add_index "guide_reports", ["guide_id"], :name => "index_guide_reports_on_guide_id"
  add_index "guide_reports", ["report_id"], :name => "index_guide_reports_on_report_id"

  create_table "guides", :force => true do |t|
    t.integer  "zip_code_id"
    t.integer  "report_id"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "secure_token", :null => false
  end

  add_index "guides", ["report_id"], :name => "index_guides_on_report_id", :unique => true
  add_index "guides", ["secure_token"], :name => "index_guides_on_secure_token", :unique => true
  add_index "guides", ["user_id"], :name => "index_guides_on_user_id"
  add_index "guides", ["zip_code_id"], :name => "index_guides_on_zip_code_id"

  create_table "images", :force => true do |t|
    t.string   "thumbnail_file_name",    :null => false
    t.string   "thumbnail_content_type", :null => false
    t.integer  "thumbnail_file_size",    :null => false
    t.datetime "thumbnail_updated_at"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "thumbnail_tiny_size"
    t.string   "thumbnail_normal_size"
    t.string   "thumbnail_header_size"
    t.string   "thumbnail_large_size"
  end

  create_table "interest_group_ratings", :force => true do |t|
    t.integer  "interest_group_report_id", :null => false
    t.integer  "politician_id",            :null => false
    t.string   "rating",                   :null => false
    t.text     "description",              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "numeric_rating"
  end

  add_index "interest_group_ratings", ["interest_group_report_id", "politician_id"], :name => "index_ig_ratings_on_p_and_ig", :unique => true
  add_index "interest_group_ratings", ["interest_group_report_id"], :name => "index_interest_group_ratings_on_interest_group_id"
  add_index "interest_group_ratings", ["politician_id"], :name => "index_interest_group_ratings_on_politician_id"

  create_table "interest_group_reports", :force => true do |t|
    t.integer  "interest_group_id", :null => false
    t.string   "timespan",          :null => false
    t.integer  "vote_smart_id",     :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interest_group_reports", ["interest_group_id"], :name => "index_interest_group_reports_on_interest_group_id"
  add_index "interest_group_reports", ["vote_smart_id"], :name => "index_interest_group_reports_on_vote_smart_id", :unique => true

  create_table "interest_group_subjects", :force => true do |t|
    t.integer  "interest_group_id", :null => false
    t.integer  "subject_id",        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "interest_group_subjects", ["interest_group_id", "subject_id"], :name => "index_interest_groups_subjects_on_group_and_subject", :unique => true
  add_index "interest_group_subjects", ["interest_group_id"], :name => "index_interest_group_subjects_on_interest_group_id"
  add_index "interest_group_subjects", ["subject_id"], :name => "index_interest_group_subjects_on_subject_id"

  create_table "interest_groups", :force => true do |t|
    t.integer  "vote_smart_id"
    t.string   "ancestry"
    t.string   "name",               :null => false
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
    t.string   "cached_slug"
    t.integer  "image_id"
    t.integer  "owner_id"
    t.datetime "ratings_updated_at"
  end

  add_index "interest_groups", ["ancestry"], :name => "index_interest_groups_on_ancestry"
  add_index "interest_groups", ["cached_slug"], :name => "index_interest_groups_on_cached_slug"
  add_index "interest_groups", ["owner_id"], :name => "index_interest_groups_on_owner_id"
  add_index "interest_groups", ["vote_smart_id"], :name => "index_interest_groups_on_vote_smart_id", :unique => true

  create_table "issue_causes", :force => true do |t|
    t.integer  "issue_id",   :null => false
    t.integer  "cause_id",   :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "issue_causes", ["cause_id"], :name => "index_issue_causes_on_cause_id"
  add_index "issue_causes", ["issue_id", "cause_id"], :name => "index_issue_causes_on_issue_id_and_cause_id"
  add_index "issue_causes", ["issue_id"], :name => "index_issue_causes_on_issue_id"

  create_table "issues", :force => true do |t|
    t.string   "title",       :null => false
    t.string   "cached_slug"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "issues", ["cached_slug"], :name => "index_issues_on_cached_slug"

  create_table "locations", :force => true do |t|
    t.string   "city"
    t.string   "state"
    t.string   "county"
    t.string   "country"
    t.string   "location_id"
    t.string   "location_name"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "zip_code_id",   :null => false
  end

  add_index "locations", ["city", "state"], :name => "index_locations_on_city_and_state"
  add_index "locations", ["city"], :name => "index_locations_on_city"
  add_index "locations", ["location_id"], :name => "index_locations_on_location_id"
  add_index "locations", ["state"], :name => "index_locations_on_state"
  add_index "locations", ["zip_code_id"], :name => "index_locations_on_zip_code_id"

  create_table "moderatorships", :force => true do |t|
    t.integer  "user_id",       :null => false
    t.integer  "created_by_id", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "moderatorships", ["created_by_id"], :name => "index_moderatorships_on_created_by_id"
  add_index "moderatorships", ["user_id"], :name => "index_moderatorships_on_user_id", :unique => true

  create_table "office_types", :force => true do |t|
    t.string "name",          :null => false
    t.string "level_id",      :null => false
    t.string "branch_id",     :null => false
    t.string "vote_smart_id", :null => false
  end

  add_index "office_types", ["vote_smart_id"], :name => "index_office_types_on_vote_smart_id", :unique => true

  create_table "offices", :force => true do |t|
    t.string  "name",           :null => false
    t.string  "title"
    t.string  "short_title"
    t.integer "office_type_id", :null => false
    t.string  "level_id",       :null => false
    t.string  "branch_id",      :null => false
    t.integer "vote_smart_id",  :null => false
  end

  add_index "offices", ["vote_smart_id"], :name => "index_offices_on_vote_smart_id", :unique => true

  create_table "parties", :force => true do |t|
    t.string   "name",       :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "parties", ["name"], :name => "index_parties_on_name"

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
    t.integer  "congressional_district_id"
    t.integer  "current_office_id"
    t.string   "current_office_type"
    t.integer  "current_candidacy_id"
    t.string   "vote_smart_photo_url"
  end

  add_index "politicians", ["bioguide_id"], :name => "index_politicians_on_bioguide_id", :unique => true
  add_index "politicians", ["cached_slug"], :name => "index_politicians_on_cached_slug"
  add_index "politicians", ["congressional_district_id"], :name => "index_politicians_on_district_id"
  add_index "politicians", ["congresspedia_url"], :name => "index_politicians_on_congresspedia_url", :unique => true
  add_index "politicians", ["crp_id"], :name => "index_politicians_on_crp_id", :unique => true
  add_index "politicians", ["email"], :name => "index_politicians_on_email", :unique => true
  add_index "politicians", ["eventful_id"], :name => "index_politicians_on_eventful_id", :unique => true
  add_index "politicians", ["fec_id"], :name => "index_politicians_on_fec_id", :unique => true
  add_index "politicians", ["gov_track_id"], :name => "index_politicians_on_gov_track_id", :unique => true
  add_index "politicians", ["metavid_id"], :name => "index_politicians_on_metavid_id", :unique => true
  add_index "politicians", ["open_secrets_id"], :name => "index_politicians_on_open_secrets_id", :unique => true
  add_index "politicians", ["phone"], :name => "index_politicians_on_phone", :unique => true
  add_index "politicians", ["twitter_id"], :name => "index_politicians_on_twitter_id", :unique => true
  add_index "politicians", ["us_state_id"], :name => "index_politicians_on_us_state_id"
  add_index "politicians", ["vote_smart_id"], :name => "index_politicians_on_vote_smart_id", :unique => true
  add_index "politicians", ["website"], :name => "index_politicians_on_website", :unique => true
  add_index "politicians", ["youtube_url"], :name => "index_politicians_on_youtube_url", :unique => true

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

  create_table "races", :force => true do |t|
    t.string  "district"
    t.integer "election_stage_id", :null => false
    t.integer "office_id",         :null => false
  end

  create_table "report_delayed_jobs", :force => true do |t|
    t.integer "report_id",      :null => false
    t.integer "delayed_job_id", :null => false
  end

  add_index "report_delayed_jobs", ["delayed_job_id"], :name => "index_report_delayed_jobs_on_delayed_job_id"
  add_index "report_delayed_jobs", ["report_id", "delayed_job_id"], :name => "index_report_delayed_jobs_on_report_id_and_delayed_job_id"
  add_index "report_delayed_jobs", ["report_id"], :name => "index_report_delayed_jobs_on_report_id"

  create_table "report_follows", :force => true do |t|
    t.integer  "user_id",    :null => false
    t.integer  "report_id",  :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "report_follows", ["report_id", "user_id"], :name => "index_report_follows_on_report_id_and_user_id", :unique => true
  add_index "report_follows", ["report_id"], :name => "index_report_follows_on_report_id"
  add_index "report_follows", ["user_id"], :name => "index_report_follows_on_user_id"

  create_table "report_score_evidences", :force => true do |t|
    t.integer  "report_score_id", :null => false
    t.integer  "evidence_id",     :null => false
    t.integer  "criterion_id",    :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "evidence_type",   :null => false
    t.string   "criterion_type",  :null => false
  end

  add_index "report_score_evidences", ["criterion_id", "criterion_type"], :name => "index_report_score_evidences_on_criterion_id_and_criterion_type"
  add_index "report_score_evidences", ["criterion_id"], :name => "index_report_score_evidences_on_criterion_id"
  add_index "report_score_evidences", ["evidence_id", "evidence_type"], :name => "index_report_score_evidences_on_evidence_id_and_evidence_type"
  add_index "report_score_evidences", ["evidence_id"], :name => "index_report_score_evidences_on_evidence_id"
  add_index "report_score_evidences", ["report_score_id"], :name => "index_report_score_evidences_on_report_score_id"

  create_table "report_scores", :force => true do |t|
    t.integer  "politician_id",        :null => false
    t.integer  "report_id",            :null => false
    t.float    "score",                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "evidence_description"
  end

  add_index "report_scores", ["politician_id"], :name => "index_report_scores_on_politician_id"
  add_index "report_scores", ["report_id"], :name => "index_report_scores_on_report_id"

  create_table "report_subjects", :force => true do |t|
    t.integer  "report_id",  :null => false
    t.integer  "subject_id", :null => false
    t.integer  "count",      :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "report_subjects", ["report_id", "subject_id"], :name => "index_report_subjects_on_report_id_and_subject_id", :unique => true
  add_index "report_subjects", ["report_id"], :name => "index_report_subjects_on_report_id"
  add_index "report_subjects", ["subject_id"], :name => "index_report_subjects_on_subject_id"

  create_table "reports", :force => true do |t|
    t.integer  "user_id"
    t.string   "name",              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.string   "cached_slug"
    t.string   "state",             :null => false
    t.integer  "interest_group_id"
    t.integer  "image_id"
    t.integer  "cause_id"
    t.string   "source"
    t.integer  "top_subject_id"
  end

  add_index "reports", ["cached_slug"], :name => "index_reports_on_cached_slug"
  add_index "reports", ["cause_id"], :name => "index_reports_on_cause_id", :unique => true
  add_index "reports", ["image_id"], :name => "index_reports_on_image_id"
  add_index "reports", ["interest_group_id"], :name => "index_reports_on_interest_group_id"
  add_index "reports", ["top_subject_id"], :name => "index_reports_on_top_subject_id"
  add_index "reports", ["user_id"], :name => "index_reports_on_user_id"

  create_table "representative_terms", :force => true do |t|
    t.integer  "politician_id",             :null => false
    t.date     "started_on"
    t.date     "ended_on"
    t.integer  "party_id"
    t.integer  "congressional_district_id", :null => false
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "representative_terms", ["congressional_district_id"], :name => "index_representative_terms_on_district_id"
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
    t.string   "display_name"
  end

  add_index "rolls", ["congress_id"], :name => "index_rolls_on_congress_id"
  add_index "rolls", ["display_name"], :name => "index_rolls_on_friendly_id"
  add_index "rolls", ["subject_id", "subject_type"], :name => "index_rolls_on_subject_id_and_subject_type"

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

  add_index "slugs", ["name", "sluggable_type", "sequence", "scope"], :name => "index_slugs_on_n_s_s_and_s", :unique => true
  add_index "slugs", ["sluggable_id"], :name => "index_slugs_on_sluggable_id"

  create_table "subjects", :force => true do |t|
    t.string  "name",          :null => false
    t.string  "cached_slug"
    t.integer "vote_smart_id"
  end

  add_index "subjects", ["cached_slug"], :name => "index_subjects_on_cached_slug"
  add_index "subjects", ["vote_smart_id"], :name => "index_subjects_on_vote_smart_id", :unique => true

  create_table "us_states", :force => true do |t|
    t.string   "abbreviation", :limit => 2, :null => false
    t.string   "full_name",                 :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "state_type",                :null => false
    t.string   "fips_code"
  end

  add_index "us_states", ["abbreviation"], :name => "index_us_states_on_abbreviation"

  create_table "users", :force => true do |t|
    t.string   "email",                             :null => false
    t.string   "crypted_password"
    t.string   "salt"
    t.string   "persistence_token"
    t.string   "username",                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "cached_slug"
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "last_login_at"
    t.datetime "current_login_at"
    t.string   "last_login_ip"
    t.string   "current_login_ip"
    t.string   "state",                             :null => false
  end

  add_index "users", ["cached_slug"], :name => "index_users_on_cached_slug"
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

  add_index "votes", ["politician_id"], :name => "index_votes_on_politician_id"
  add_index "votes", ["roll_id"], :name => "index_votes_on_roll_id"

  create_table "zip_codes", :force => true do |t|
    t.integer "zip_code",                   :null => false
    t.float   "lat"
    t.float   "lng"
    t.string  "population"
    t.string  "housing_units"
    t.string  "income"
    t.string  "land_area"
    t.string  "water_area"
    t.string  "zip_code_type"
    t.string  "military_restriction_codes"
    t.boolean "primary"
    t.boolean "decommissioned"
    t.string  "world_region"
  end

  add_index "zip_codes", ["zip_code"], :name => "index_zip_codes_on_zip_code", :unique => true

  add_foreign_key "adminships", "users", :name => "adminships_created_by_id_reference", :column => "created_by_id"
  add_foreign_key "adminships", "users", :name => "adminships_user_id_reference"

  add_foreign_key "amendment_criteria", "amendments", :name => "amendment_criteria_amendment_id_fk"

  add_foreign_key "bill_criteria", "bills", :name => "bill_criteria_bill_id_reference", :dependent => :delete
  add_foreign_key "bill_criteria", "reports", :name => "bill_criteria_report_id_reference", :dependent => :delete

  add_foreign_key "bills", "cosponsorships", :name => "bills_sponsorship_id_fk", :column => "sponsorship_id"

  add_foreign_key "candidacies", "politicians", :name => "candidacies_politician_id_fk"
  add_foreign_key "candidacies", "races", :name => "candidacies_race_id_fk"

  add_foreign_key "cause_reports", "causes", :name => "cause_reports_cause_id_reference"
  add_foreign_key "cause_reports", "reports", :name => "cause_reports_report_id_reference"

  add_foreign_key "congressional_district_zip_codes", "congressional_districts", :name => "district_zip_codes_district_id_reference"
  add_foreign_key "congressional_district_zip_codes", "zip_codes", :name => "district_zip_codes_zip_code_id_reference"

  add_foreign_key "congressional_districts", "us_states", :name => "congressional_districts_us_state_id_fk"

  add_foreign_key "districts", "us_states", :name => "districts_us_state_id_fk"

  add_foreign_key "election_stages", "elections", :name => "election_stages_election_id_fk"

  add_foreign_key "elections", "us_states", :name => "elections_state_id_fk", :column => "state_id"

  add_foreign_key "guide_reports", "guides", :name => "guide_reports_guide_id_reference"
  add_foreign_key "guide_reports", "reports", :name => "guide_reports_report_id_reference"

  add_foreign_key "guides", "reports", :name => "guides_report_id_reference"
  add_foreign_key "guides", "users", :name => "guides_user_id_reference"
  add_foreign_key "guides", "zip_codes", :name => "guides_zip_code_id_reference"

  add_foreign_key "interest_group_ratings", "interest_group_reports", :name => "interest_group_ratings_interest_group_report_id_reference"
  add_foreign_key "interest_group_ratings", "politicians", :name => "interest_group_ratings_politician_id_reference"

  add_foreign_key "interest_group_reports", "interest_groups", :name => "interest_group_reports_interest_group_id_reference"

  add_foreign_key "interest_group_subjects", "interest_groups", :name => "interest_group_subjects_interest_group_id_reference"
  add_foreign_key "interest_group_subjects", "subjects", :name => "interest_group_subjects_subject_id_reference"

  add_foreign_key "interest_groups", "images", :name => "interest_groups_image_id_reference"
  add_foreign_key "interest_groups", "users", :name => "interest_groups_owner_id_fk", :column => "owner_id"

  add_foreign_key "issue_causes", "causes", :name => "issue_causes_cause_id_reference"
  add_foreign_key "issue_causes", "issues", :name => "issue_causes_issue_id_reference"

  add_foreign_key "locations", "zip_codes", :name => "location_zip_codes_zip_code_id_reference"

  add_foreign_key "moderatorships", "users", :name => "moderatorships_created_by_id_reference", :column => "created_by_id"
  add_foreign_key "moderatorships", "users", :name => "moderatorships_user_id_reference"

  add_foreign_key "offices", "office_types", :name => "offices_office_type_id_fk"

  add_foreign_key "politicians", "candidacies", :name => "politicians_current_candidacy_id_fk", :column => "current_candidacy_id", :dependent => :nullify
  add_foreign_key "politicians", "congressional_districts", :name => "politicians_district_id_reference"

  add_foreign_key "presidential_terms", "parties", :name => "presidential_terms_party_id_reference"
  add_foreign_key "presidential_terms", "politicians", :name => "presidential_terms_politician_id_reference"

  add_foreign_key "races", "election_stages", :name => "races_election_stage_id_fk"
  add_foreign_key "races", "offices", :name => "races_office_id_fk"

  add_foreign_key "report_delayed_jobs", "delayed_jobs", :name => "report_delayed_jobs_delayed_job_id_reference", :dependent => :delete
  add_foreign_key "report_delayed_jobs", "reports", :name => "report_delayed_jobs_report_id_reference", :dependent => :delete

  add_foreign_key "report_follows", "reports", :name => "report_follows_report_id_reference"
  add_foreign_key "report_follows", "users", :name => "report_follows_user_id_reference"

  add_foreign_key "report_score_evidences", "report_scores", :name => "report_score_evidences_report_score_id_fk"

  add_foreign_key "report_subjects", "reports", :name => "report_subjects_report_id_reference", :dependent => :delete
  add_foreign_key "report_subjects", "subjects", :name => "report_subjects_subject_id_reference", :dependent => :delete

  add_foreign_key "reports", "causes", :name => "reports_cause_id_reference"
  add_foreign_key "reports", "images", :name => "reports_thumbnail_id_reference"
  add_foreign_key "reports", "interest_groups", :name => "reports_interest_group_id_reference"
  add_foreign_key "reports", "subjects", :name => "reports_top_subject_id_fk", :column => "top_subject_id", :dependent => :nullify
  add_foreign_key "reports", "users", :name => "reports_user_id_fk"

  add_foreign_key "representative_terms", "congressional_districts", :name => "representative_terms_district_id_reference"
  add_foreign_key "representative_terms", "parties", :name => "representative_terms_party_id_reference"
  add_foreign_key "representative_terms", "politicians", :name => "representative_terms_politician_id_reference"

  add_foreign_key "rpx_identifiers", "users", :name => "rpx_identifiers_user_id_reference", :dependent => :delete

  add_foreign_key "senate_terms", "parties", :name => "senate_terms_party_id_reference"
  add_foreign_key "senate_terms", "politicians", :name => "senate_terms_politician_id_reference"
  add_foreign_key "senate_terms", "us_states", :name => "senate_terms_us_state_id_reference"

end
