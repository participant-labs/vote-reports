class CreateCommitteeMemberships < ActiveRecord::Migration
  def self.up
    create_table :committee_memberships do |t|
      t.integer :politician_id, :null => false
      t.integer :committee_meeting_id, :null => false
      t.string :role

      t.timestamps
    end
    constrain :committee_memberships do |t|
      t.politician_id :reference => {:politicians => :id, :on_delete => :cascade}
      t.committee_meeting_id :reference => {:committee_meetings => :id, :on_delete => :cascade}
      t[:politician_id, :committee_meeting_id].all :unique => true
    end
  end

  def self.down
    drop_table :committee_memberships
  end
end
