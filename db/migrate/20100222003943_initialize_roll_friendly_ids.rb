class InitializeRollFriendlyIds < ActiveRecord::Migration
  def self.up
    Roll.all.each(&:save!)
  end

  def self.down
  end
end
