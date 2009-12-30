class AddConstraintsToBills < ActiveRecord::Migration
  def self.up
    constrain :bills do |t|
      t.bill_type :not_blank => true, :not_null => true
      t.congress_id :not_null => true, :reference => {:congresses => :id, :on_delete => :cascade}
      t[:bill_type, :bill_number, :congress_id].all :unique => true
      t.opencongress_id :unique => true, :not_blank => true, :not_null => true
      t.gov_track_id :unique => true, :not_blank => true, :not_null => true
      t.sponsor_id :reference => {:politicians => :id, :on_delete => :cascade}
    end
  end

  def self.down
    constrain :bills do |t|
      t.bill_type :not_blank, :not_null
      t.congress_id :not_null, :reference
      t[:bill_type, :bill_number, :congress_id].all :unique
      t.opencongress_id :unique, :not_blank, :not_null
      t.gov_track_id :unique, :not_blank, :not_null
      t.sponsor_id :reference
    end
  end
end
