class PopulateContinuousTerms < ActiveRecord::Migration
  def self.up
    ContinuousTerm.regenerate!
  end

  def self.down
  end
end
