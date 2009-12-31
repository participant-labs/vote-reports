class AddConstraintsToAmendments < ActiveRecord::Migration
  def self.up
    constrain :amendments do |t|
      t.bill_id :reference => {:bills => :id, :on_delete => :cascade}, :not_null => true
      t.sponsor_id :reference => {:politicians => :id}
      t.congress_id :reference => {:congresses => :id, :on_delete => 'SET NULL'}, :not_null => true

      t.number :not_null => true
      t.chamber :not_null => true, :whitelist => %w[h s]
      t.offered_on :not_null => true

      t[:number, :chamber, :congress_id].all :unique => true
      t[:sequence, :bill_id].all :unique => true
    end
  end

  def self.down
    deconstrain :amendments do |t|
      t.bill_id :reference, :not_null
      t.sponsor_id :reference
      t.congress_id :reference, :not_null

      t.number :not_null
      t.chamber :not_null, :within
      t.offered_on :not_null

      t[:number, :chamber, :congress_id].all :unique
      t[:sequence, :bill_id].all :unique
    end
  end
end
