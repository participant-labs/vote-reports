class UniqueIndexOnReportCause < ActiveRecord::Migration
  def self.up
    add_index :reports, :cause_id, :unique => true
  end

  def self.down
    remove_index :reports, :cause_id
  end
end
