class ConstrainRollVotedAtIsNeverNull < ActiveRecord::Migration
  def self.up
    change_column :rolls, :voted_at, :datetime, :null => false
  end

  def self.down
    change_column :rolls, :voted_at, :datetime, :null => true
  end
end
