class RegeneratePoliticianFriendlyIdsWithoutDiacritics < ActiveRecord::Migration
  def self.up
    Politician.all.each do |p|
      p.save!
      $stdout.print '.'
      $stdout.flush
    end
  end

  def self.down
  end
end
