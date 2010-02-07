class ChangeReportPrivateToPersonal < ActiveRecord::Migration
  def self.up
    Report.update_all({:state => 'personal'}, {:state => 'private'})
  end

  def self.down
  end
end
