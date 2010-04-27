class UniqueIndicesOnBillTables < ActiveRecord::Migration
  def self.up
    add_index :cosponsorships, [:bill_id, :politician_id], :unique => true
    add_index :bill_subjects, [:bill_id, :subject_id], :unique => true
    add_index :bill_subjects, :bill_id
    add_index :bill_subjects, :subject_id
    add_index :bill_titles, :bill_id
    add_index :bill_supports, [:bill_id, :politician_id], :unique => true
    add_index :bill_supports, :bill_id
    add_index :bill_supports, :politician_id
  end

  def self.down
    raise 'nope'
  end
end
