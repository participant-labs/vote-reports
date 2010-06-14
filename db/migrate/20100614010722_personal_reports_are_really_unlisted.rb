class PersonalReportsAreReallyUnlisted < ActiveRecord::Migration
  def self.up
    Report.update_all({:state => 'unlisted'}, {:state => 'personal'})
  end

  def self.down
  end
end
