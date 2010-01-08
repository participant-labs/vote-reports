class AddConstraintsToAmendments < ActiveRecord::Migration
  def self.up
    change_table :amendments do |t|
      t.change :bill_id, :integer, :null => false
      t.change :congress_id, :integer, :null => false
      t.change :number, :integer, :null => false
      t.change :chamber, :string, :null => false
      t.change :offered_on, :date, :null => false
      t.change :sponsor_id, :integer, :null => false
      t.change :sponsor_type, :string, :null => false
    end

    constrain :amendments do |t|
      t.bill_id :reference => {:bills => :id, :on_delete => :cascade}
      t.congress_id :reference => {:congresses => :id, :on_delete => 'SET NULL'}

      t.chamber :whitelist => %w[h s]
      t.sponsor_type :whitelist => %w[Politician CommitteeMeeting]

      t[:number, :chamber, :congress_id].all :unique => true
      t[:number, :bill_id].all :unique => true
      t[:sequence, :bill_id].all :unique => true
    end
  end

  def self.down
    change_table :amendments do |t|
      t.change :bill_id, :integer, :null => true
      t.change :congress_id, :integer, :null => true
      t.change :number, :integer, :null => true
      t.change :chamber, :string, :null => true
      t.change :offered_on, :date, :null => true
    end

    deconstrain :amendments do |t|
      t.bill_id :reference
      t.congress_id :reference

      t.chamber :whitelist

      t[:number, :chamber, :congress_id].all :unique
      t[:number, :bill_id].all :unique
      t[:sequence, :bill_id].all :unique
    end
  end
end
