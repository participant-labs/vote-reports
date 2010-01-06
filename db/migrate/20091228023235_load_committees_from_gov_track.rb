class LoadCommitteesFromGovTrack < ActiveRecord::Migration
  def self.up
    Rake::Task['gov_track:committees:unpack'].invoke
  end

  def self.down
  end
end
