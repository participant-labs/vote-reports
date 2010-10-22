class UpdateInterestGroupScores < ActiveRecord::Migration
  def self.up
    InterestGroupReport.calibrate_ratings
  end

  def self.down
  end
end
