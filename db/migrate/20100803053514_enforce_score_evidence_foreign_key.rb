class EnforceScoreEvidenceForeignKey < ActiveRecord::Migration
  def self.up
    ReportScoreEvidence.delete_all
    ReportScore.delete_all
    GuideScore.delete_all

    add_foreign_key 'report_score_evidences', 'report_scores'
  end

  def self.down
    remove_foreign_key 'report_score_evidences', 'report_scores'
  end
end
