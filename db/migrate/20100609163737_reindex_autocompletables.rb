class ReindexAutocompletables < ActiveRecord::Migration
  def self.up
    [Subject, Report, Politician].each(&:reindex)
  end

  def self.down
  end
end
