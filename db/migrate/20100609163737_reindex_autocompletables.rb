class ReindexAutocompletables < ActiveRecord::Migration
  def self.up
    [Subject, Report, Politician].each(&:solr_reindex)
  end

  def self.down
  end
end
