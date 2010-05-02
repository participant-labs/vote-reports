class ReportStateShouldNotBeNull < ActiveRecord::Migration
  def self.up
    Report.update_all({:state => 'personal'}, {:state => nil})
    change_column :reports, :state, :string, :null => false
  end

  def self.down
    change_column :reports, :state, :string, :null => true
  end
end
