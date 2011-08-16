class ReindexReportsForInterestGroupName < ActiveRecord::Migration
  def self.up
    Report.solr_reindex
  end

  def self.down
  end
end
