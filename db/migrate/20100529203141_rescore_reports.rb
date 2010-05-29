class RescoreReports < ActiveRecord::Migration
  def self.up
    Report.paginated_each do |report|
      report.rescore!
    end
  end

  def self.down
  end
end
