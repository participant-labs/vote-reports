class LoadBillsFromGovTrack < ActiveRecord::Migration
  def self.up
    Rake::Task['gov_track:bills:unpack'].invoke
  end

  def self.down
  end
end
