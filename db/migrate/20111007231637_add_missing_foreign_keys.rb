class AddMissingForeignKeys < ActiveRecord::Migration
  def change
    add_foreign_key :amendment_criteria, :reports, dependent: :delete
    add_foreign_key :amendments, :bills
    add_foreign_key :amendments, :congresses
    add_foreign_key :bill_committee_actions, :committee_meetings
    add_foreign_key :bill_committee_actions, :bills
    add_foreign_key :bill_subjects, :bills
    add_foreign_key :bill_subjects, :subjects
    add_foreign_key :committee_meetings, :congresses
    add_foreign_key :committee_meetings, :committees
    add_foreign_key :report_scores, :politicians
    add_foreign_key :report_scores, :reports
    add_foreign_key :rolls, :congresses
    add_foreign_key :votes, :politicians
    add_foreign_key :votes, :rolls
  end
end
