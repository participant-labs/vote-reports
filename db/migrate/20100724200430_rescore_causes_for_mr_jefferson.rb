class RescoreCausesForMrJefferson < ActiveRecord::Migration
  def self.up
    Cause.all.each(&:rescore!)
  end

  def self.down
    raise 'Nope'
  end
end
