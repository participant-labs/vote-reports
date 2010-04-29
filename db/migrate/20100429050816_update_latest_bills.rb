class UpdateLatestBills < ActiveRecord::Migration
  def self.up
    ENV['MEETING'] = '111'
    ENV['UPDATE'] = 'true'
    Rake::Task['gov_track:bills:unpack'].invoke
  end

  def self.down
  end
end
