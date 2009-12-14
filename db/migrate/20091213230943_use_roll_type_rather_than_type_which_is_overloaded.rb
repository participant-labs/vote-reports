class UseRollTypeRatherThanTypeWhichIsOverloaded < ActiveRecord::Migration
  def self.up
    rename_column :rolls, :type, :roll_type
  end

  def self.down
    rename_column :rolls, :roll_type, :type
  end
end
