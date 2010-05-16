class ReindexReportsForInterestGroupName < ActiveRecord::Migration
  def self.up
    Report.reindex
  end

  def self.down
  end
end
