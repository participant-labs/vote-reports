class CreateReportCriteria < ActiveRecord::Migration
  def self.up
    create_table :report_criteria do |t|
      t.integer :report_id, :null => false
      t.integer :criteria_report_id, :null => false

      t.timestamps
    end

    constrain :report_criteria do |t|
      t.report_id :reference => {:reports => :id}
      t.criteria_report_id :reference => {:reports => :id}
    end

    add_index :report_criteria, :report_id
    add_index :report_criteria, :criteria_report_id
    add_index :report_criteria, [:report_id, :criteria_report_id], :unique => true
  end

  def self.down
    drop_table :report_criteria
  end
end
