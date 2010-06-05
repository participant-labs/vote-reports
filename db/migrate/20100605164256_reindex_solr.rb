class ReindexSolr < ActiveRecord::Migration
  def self.up
    Politician.reindex
    Report.reindex
    Subject.reindex
  end

  def self.down
  end
end
