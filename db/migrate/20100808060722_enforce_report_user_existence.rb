class EnforceReportUserExistence < ActiveRecord::Migration
  def self.up
    add_foreign_key :reports, :users
  end

  def self.down
    remove_foreign_key :reports, :users
  end
end
