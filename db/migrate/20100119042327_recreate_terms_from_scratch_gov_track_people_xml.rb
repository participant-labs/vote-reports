class RecreateTermsFromScratchGovTrackPeopleXml < ActiveRecord::Migration
  def self.up
    PoliticianTerm.delete_all
    Rake::Task['gov_track:politicians:unpack'].invoke
  end

  def self.down
  end
end
