class LoadVotesFromGovTrack < ActiveRecord::Migration
  def self.up
    Rake::Task['gov_track:votes:unpack'].invoke
  end

  def self.down
  end
end
