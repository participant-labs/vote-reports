class CreateReportScoreEvidences < ActiveRecord::Migration
  def self.up
    create_table :report_score_evidences do |t|
      t.integer :report_score_id, :null => false
      t.integer :vote_id, :null => false
      t.integer :bill_criterion_id, :null => false

      t.timestamps
    end
    constrain :report_score_evidences do |t|
      t.report_score_id :reference => {:report_scores => :id}
      t.vote_id :reference => {:votes => :id}
      t.bill_criterion_id :reference => {:bill_criteria => :id}
    end
  end

  def self.down
    drop_table :report_score_evidences
  end
end
