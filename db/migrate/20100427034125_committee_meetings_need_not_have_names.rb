class CommitteeMeetingsNeedNotHaveNames < ActiveRecord::Migration
  def self.up
    change_column :committee_meetings, :name, :string, :null => true
  end

  def self.down
    change_column :committee_meetings, :name, :string, :null => false
  end
end
