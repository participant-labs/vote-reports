class AddOlderAmendments < ActiveRecord::Migration
  def self.up
    ENV['MEETING'] = '101,102'
    Rake::Task['gov_track:amendments:unpack'].invoke
  end

  def self.down
  end
end
