class IndexesForBillTitlesAndSuch < ActiveRecord::Migration
  def self.up
    add_index :bill_titles, :bill_id
    add_index :bill_committee_actions, :bill_id
    add_index :bill_committee_actions, :committee_meeting_id
    add_index :bill_criteria, :bill_id
    add_index :bill_criteria, :support
    add_index :bill_subjects, :bill_id
    add_index :bill_subjects, :subject_id
    add_index :bill_title_as, :as
    add_index :bill_titles, :bill_title_as_id
    add_index :bills, :congress_id
    add_index :bills, :sponsor_id
    add_index :committee_meetings, :congress_id
    add_index :committee_meetings, :committee_id
    add_index :committee_memberships, :committee_meeting_id
    add_index :committee_memberships, :politician_id
    add_index :cosponsorships, :bill_id
    add_index :cosponsorships, :politician_id
    add_index :politician_terms, :politician_id
    add_index :politician_terms, :party_id
    add_index :reports, :user_id
    add_index :rolls, :congress_id
    add_index :rolls, :subject_id
    add_index :votes, :roll_id
    add_index :subjects, :name, :unique => true
    add_index :amendments, :bill_id
    add_index :amendments, :congress_id
    add_index :amendments, [:sponsor_id, :sponsor_type]
  end

  def self.down
    remove_index :bill_titles, :bill_id
    remove_index :bill_committee_actions, :bill_id
    remove_index :bill_committee_actions, :committee_meeting_id
    remove_index :bill_criteria, :bill_id
    remove_index :bill_criteria, :support
    remove_index :bill_subjects, :bill_id
    remove_index :bill_subjects, :subject_id
    remove_index :bill_title_as, :as
    remove_index :bill_titles, :bill_id
    remove_index :bill_titles, :bill_title_as_id
    remove_index :bills, :congress_id
    remove_index :bills, :sponsor_id
    remove_index :committee_meetings, :congress_id
    remove_index :committee_meetings, :committee_id
    remove_index :committee_memberships, :committee_meeting_id
    remove_index :committee_memberships, :politician_id
    remove_index :cosponsorships, :bill_id
    remove_index :cosponsorships, :politician_id
    remove_index :politician_terms, :politician_id
    remove_index :politician_terms, :party_id
    remove_index :reports, :user_id
    remove_index :rolls, :congress_id
    remove_index :rolls, :subject_id
    remove_index :votes, :roll_id
    remove_index :subjects, :name, :unique => true
    remove_index :amendments, :bill_id
    remove_index :amendments, :congress_id
    remove_index :amendments, [:sponsor_id, :sponsor_type]
  end
end
