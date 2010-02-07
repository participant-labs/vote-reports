class AllReportsAreInPrivateState < ActiveRecord::Migration
  def self.up
    Report.update_all(:state => 'private')
    Report.all.each do |report|
      report.publish
    end
  end

  def self.down
  end
end
