class ReindexSolr < ActiveRecord::Migration
  def self.up
    Politician.solr_reindex
    Report.solr_reindex
    Subject.solr_reindex
  end

  def self.down
  end
end
