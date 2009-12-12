class LoadGovtrackForAllPoliticians < ActiveRecord::Migration
  def self.up
    Rake::Task['gov_track:politicians:unpack'].invoke
  end

  def self.down
  end
end
