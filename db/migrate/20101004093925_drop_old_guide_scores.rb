class DropOldGuideScores < ActiveRecord::Migration
  def self.up
    GuideScore.delete_all
    GuideScore::Evidence.delete_all
  end

  def self.down
  end
end
