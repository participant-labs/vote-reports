class LoadAmendmentsFromGovTrack < ActiveRecord::Migration
  def self.up
    Rake::Task['gov_track:amendments:unpack'].invoke
  end

  def self.down
  end
end
