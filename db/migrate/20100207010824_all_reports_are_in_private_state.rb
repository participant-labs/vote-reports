class AllReportsAreInPrivateState < ActiveRecord::Migration
  def self.up
    Report.update_all(:state => 'private')
  end

  def self.down
  end
end
