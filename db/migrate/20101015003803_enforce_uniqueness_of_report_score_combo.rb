class EnforceUniquenessOfReportScoreCombo < ActiveRecord::Migration
  def self.up
    add_index :report_scores, [:politician_id, :report_id], :unique => true
  end

  def self.down
    remove_index :report_scores, [:politician_id, :report_id]
  end
end
