class RemoveUnusedRollTitle < ActiveRecord::Migration
  def self.up
    remove_column :rolls, :title
  end

  def self.down
    add_column :rolls, :title, :text
  end
end
