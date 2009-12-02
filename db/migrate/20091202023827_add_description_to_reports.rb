class AddDescriptionToReports < ActiveRecord::Migration
  def self.up
    add_column :reports, :description, :text
  end

  def self.down
    remove_column :reports, :description
  end
end
