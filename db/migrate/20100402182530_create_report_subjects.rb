class CreateReportSubjects < ActiveRecord::Migration
  def self.up
    create_table :report_subjects do |t|
      t.integer :report_id, :null => false
      t.integer :subject_id, :null => false
      t.integer :count, :null => false

      t.timestamps
    end
    constrain :report_subjects do |t|
      t.report_id :reference => {:reports => :id, :on_delete => :cascade}
      t.subject_id :reference => {:subjects => :id, :on_delete => :cascade}
      t.count :positive => true
    end
    add_index :report_subjects, [:report_id, :subject_id], :unique => true
  end

  def self.down
    drop_table :report_subjects
  end
end
