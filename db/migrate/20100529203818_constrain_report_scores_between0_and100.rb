class ConstrainReportScoresBetween0And100 < ActiveRecord::Migration
  def self.up
    constrain :report_scores do |t|
      t.score :within => (-Float::EPSILON..(100.0 + Float::EPSILON))
    end
  end

  def self.down
  end
end
