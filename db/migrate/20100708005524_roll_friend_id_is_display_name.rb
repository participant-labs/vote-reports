class RollFriendIdIsDisplayName < ActiveRecord::Migration
  def self.up
    rename_column :rolls, :friendly_id, :display_name
  end

  def self.down
    rename_column :rolls, :display_name, :friendly_id
  end
end
