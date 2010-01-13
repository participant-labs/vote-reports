class ReloadMissingBillTitlesFromGovTrack < ActiveRecord::Migration
  def self.up
    Rake::Task['gov_track:bills:titles:unpack'].invoke
  end

  def self.down
  end
end
