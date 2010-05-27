class CreateCauseReports < ActiveRecord::Migration
  def self.up
    create_table :cause_reports do |t|
      t.integer :report_id, :null => false
      t.integer :cause_id, :null => false

      t.timestamps
    end
    constrain :cause_reports do |t|
      t.report_id :reference => {:reports => :id}
      t.cause_id :reference => {:causes => :id}
    end
  end

  def self.down
    drop_table :cause_reports
  end
end
