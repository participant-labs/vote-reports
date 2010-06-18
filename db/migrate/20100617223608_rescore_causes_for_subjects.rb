class RescoreCausesForSubjects < ActiveRecord::Migration
  def self.up
    Cause.all.each(&:rescore!)
  end

  def self.down
  end
end
