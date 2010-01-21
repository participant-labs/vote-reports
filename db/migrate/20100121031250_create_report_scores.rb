class CreateReportScores < ActiveRecord::Migration
  def self.up
    create_table :report_scores do |t|
      t.integer :politician_id, :null => false
      t.integer :report_id, :null => false
      t.float :score, :null => false

      t.timestamps
    end
    constrain :report_scores do |t|
      t.politician_id :reference => {:politicians => :id}
      t.report_id :reference => {:reports => :id}
    end
  end

  def self.down
    drop_table :report_scores
  end
end
