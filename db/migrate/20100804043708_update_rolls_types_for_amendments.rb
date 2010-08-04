class UpdateRollsTypesForAmendments < ActiveRecord::Migration
  def self.up
    Roll.update_roll_types_for_consistency!
  end

  def self.down
  end
end
