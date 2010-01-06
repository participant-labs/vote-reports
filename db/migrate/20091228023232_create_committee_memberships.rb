class CreateCommitteeMemberships < ActiveRecord::Migration
  def self.up
    create_table :committee_memberships do |t|
      t.integer :congress_id, :null => false
      t.integer :politician_id, :null => false
      t.integer :committee_id, :null => false
      t.string :role

      t.timestamps
    end
    constrain :committee_memberships do |t|
      t.congress_id :reference => {:congresses => :id, :on_delete => :cascade}
      t.politician_id :reference => {:politicians => :id, :on_delete => :cascade}
      t.committee_id :reference => {:committees => :id, :on_delete => :cascade}
      t[:politician_id, :congress_id, :committee_id].all :unique => true
    end
  end

  def self.down
    drop_table :committee_memberships
  end
end
