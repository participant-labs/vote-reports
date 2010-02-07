class AddStateToReport < ActiveRecord::Migration
  def self.up
    add_column :reports, :state, :string
  end

  def self.down
    remove_column :reports, :state
  end
end
