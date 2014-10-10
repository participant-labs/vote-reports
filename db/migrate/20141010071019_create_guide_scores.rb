class CreateGuideScores < ActiveRecord::Migration
  def change
    create_table :guide_scores do |t|
      t.integer :guide_id, null: false
      t.integer :politician_id, null: false
      t.float :score, null: false
      t.text :evidence_description
      t.timestamps
    end
    add_foreign_key :guide_scores, :guides
    add_foreign_key :guide_scores, :politicians

    create_table :guide_score_evidences do |t|
      t.integer :guide_score_id, null: false
      t.integer :report_score_id, null: false
      t.boolean :support, null: false
      t.timestamps
    end
    add_foreign_key :guide_score_evidences, :guide_scores
    add_foreign_key :guide_score_evidences, :report_scores
  end
end
