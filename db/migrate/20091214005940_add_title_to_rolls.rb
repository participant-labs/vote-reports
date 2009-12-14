class AddTitleToRolls < ActiveRecord::Migration
  def self.up
    add_column :rolls, :title, :text
  end

  def self.down
    remove_column :rolls, :title
  end
end
