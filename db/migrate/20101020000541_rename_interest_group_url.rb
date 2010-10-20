class RenameInterestGroupUrl < ActiveRecord::Migration
  def self.up
    rename_column :interest_groups, :url, :website_url
  end

  def self.down
    rename_column :interest_groups, :website_url, :url
  end
end
