class CreateBillCommitteeActions < ActiveRecord::Migration
  def self.up
    create_table :bill_committee_actions do |t|
      t.string :action, :null => false
      t.integer :committee_meeting_id, :null => false
      t.integer :bill_id, :null => false

      t.timestamps
    end
    constrain :bill_committee_actions do |t|
      t.action :not_blank => true
      t.committee_meeting_id :reference => {:committee_meetings => :id, :on_delete => :cascade}
      t.bill_id :reference => {:bills => :id, :on_delete => :cascade}
    end
  end

  def self.down
    drop_table :bill_committee_actions
  end
end
