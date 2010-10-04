class RequireStateForElections < ActiveRecord::Migration
  def self.up
    change_column_null :elections, :state_id, false
  end

  def self.down
    change_column_null :elections, :state_id, true
  end
end
