class UpdateLatestBills < ActiveRecord::Migration
  def self.up
    Rake::Task['gov_track:download_all'].invoke
    Rake::Task['gov_track:politicians:unpack'].invoke
    Rake::Task['gov_track:committees:unpack'].invoke
    ENV['MEETING'] = '111'
    ENV['UPDATE'] = 'true'
    Rake::Task['gov_track:bills:unpack'].invoke
  end

  def self.down
  end
end
