class AddConstraintsToBills < ActiveRecord::Migration
  def self.up
    change_table :bills do |t|
      t.change :bill_type, :string, :null => false
      t.change :congress_id, :integer, :null => false
      t.change :opencongress_id, :string, :null => false
      t.change :gov_track_id, :string, :null => false
      t.change :introduced_on, :date, :null => false
    end

    constrain :bills do |t|
      t.bill_type :not_blank => true, :whitelist => BillType.valid_types
      t.congress_id :reference => {:congresses => :id, :on_delete => :cascade}
      t[:bill_type, :bill_number, :congress_id].all :unique => true
      t.opencongress_id :unique => true, :not_blank => true
      t.gov_track_id :unique => true, :not_blank => true
      t.sponsor_id :reference => {:politicians => :id, :on_delete => :cascade}
    end
  end

  def self.down
    change_table :bills do |t|
      t.change :bill_type, :string, :null => true
      t.change :congress_id, :integer, :null => true
      t.change :opencongress_id, :string, :null => true
      t.change :gov_track_id, :string, :null => true
      t.change :introduced_on, :date, :null => true
    end

    constrain :bills do |t|
      t.bill_type :not_blank
      t.congress_id :reference
      t[:bill_type, :bill_number, :congress_id].all :unique
      t.opencongress_id :unique, :not_blank
      t.gov_track_id :unique, :not_blank
      t.sponsor_id :reference
    end
  end
end
