class GeneralizeReportScoreEvidence < ActiveRecord::Migration
  def self.up
    rename_column :report_score_evidences, :vote_id, :evidence_id
    add_column :report_score_evidences, :evidence_type, :string
    ReportScoreEvidence.update_all(:evidence_type => 'Vote')
    change_column :report_score_evidences, :evidence_type, :string, :null => false

    rename_column :report_score_evidences, :bill_criterion_id, :criterion_id
    add_column :report_score_evidences, :criterion_type, :string
    ReportScoreEvidence.update_all(:criterion_type => 'BillCriterion')
    change_column :report_score_evidences, :criterion_type, :string, :null => false
  end

  def self.down
    raise "Nope"
  end
end
