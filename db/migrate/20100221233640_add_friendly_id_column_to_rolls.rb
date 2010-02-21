class AddFriendlyIdColumnToRolls < ActiveRecord::Migration
  def self.up
    add_column :rolls, :friendly_id, :string
  end

  def self.down
    remove_column :rolls, :friendly_id
  end
end
