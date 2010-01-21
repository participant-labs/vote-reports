class GenerateAllReportScores < ActiveRecord::Migration
  def self.up
    Report.all.each do |report|
      report.rescore!
      $stdout.print '.'
      $stdout.flush
    end
  end

  def self.down
  end
end
