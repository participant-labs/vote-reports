class AddMissingIndexes < ActiveRecord::Migration
  def self.up
    add_index :adminships, :user_id, :unique => true
    add_index :adminships, :created_by_id
    add_index :bill_criteria, :report_id
    add_index :bill_titles, :bill_title_as_id
    add_index :bills, :congress_id
    add_index :bills, :sponsor_id
    add_index :committee_meetings, :congress_id
    add_index :committee_meetings, :committee_id
    add_index :committee_memberships, :politician_id
    add_index :committee_memberships, :committee_meeting_id
    add_index :cosponsorships, :bill_id
    add_index :cosponsorships, :politician_id
    add_index :delayed_jobs, [:priority, :run_at]
    add_index :interest_group_reports, :interest_group_id
    add_index :locations, :zip_code_id
    add_index :locations, :location_id
    add_index :locations, :city
    add_index :locations, :state
    add_index :locations, [:city, :state]
    add_index :moderatorships, :user_id, :unique => true
    add_index :moderatorships, :created_by_id
    add_index :parties, :name
    add_index :politicians, :district_id
    add_index :politicians, :us_state_id
    add_index :report_delayed_jobs, :report_id
    add_index :report_delayed_jobs, :delayed_job_id
    add_index :report_delayed_jobs, [:report_id, :delayed_job_id]
    add_index :report_score_evidences, :report_score_id
    add_index :report_score_evidences, :criterion_id
    add_index :report_score_evidences, [:criterion_id, :criterion_type]
    add_index :report_score_evidences, :evidence_id
    add_index :report_score_evidences, [:evidence_id, :evidence_type]
    add_index :report_scores, :report_id
    add_index :report_scores, :politician_id
    add_index :report_subjects, :report_id
    add_index :report_subjects, :subject_id
    add_index :reports, :user_id
    add_index :reports, :interest_group_id
    add_index :reports, :image_id
    add_index :rolls, :congress_id
    add_index :rolls, [:subject_id, :subject_type]
    add_index :rolls, :friendly_id
    add_index :slugs, :sluggable_id
    add_index :slugs, [:name, :sluggable_type, :sequence, :scope], :name => "index_slugs_on_n_s_s_and_s", :unique => true
    add_index :us_states, :abbreviation
    add_index :votes, :politician_id
    add_index :votes, :roll_id
  end

  def self.down
    raise 'nope'
  end
end
