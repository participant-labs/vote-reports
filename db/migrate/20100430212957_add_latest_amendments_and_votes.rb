class AddLatestAmendmentsAndVotes < ActiveRecord::Migration
  def self.up
    ENV['MEETING'] = '111'
    Rake::Task['gov_track:amendments:unpack'].invoke
    ENV['MEETING'] = '101,102,111'
    Rake::Task['gov_track:votes:unpack'].invoke
  end

  def self.down
  end
end
