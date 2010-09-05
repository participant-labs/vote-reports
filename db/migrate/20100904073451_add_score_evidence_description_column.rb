class AddScoreEvidenceDescriptionColumn < ActiveRecord::Migration
  def self.up
    add_column :report_scores, :evidence_description, :string
    GuideScore.delete_all
    GuideScore::Evidence.delete_all
    Report.rescore!
  end

  def self.down
    remove_column :report_scores, :evidence_description, :string
  end
end
