class CreateGuideReports < ActiveRecord::Migration
  def self.up
    create_table :guide_reports do |t|
      t.integer :guide_id, :null => false
      t.integer :report_id, :null => false

      t.timestamps
    end
    constrain :guide_reports do |t|
      t.guide_id :reference => {:guides => :id}
      t.report_id :reference => {:reports => :id}
    end
    add_index :guide_reports, :guide_id
    add_index :guide_reports, :report_id
    add_index :guide_reports, [:guide_id, :report_id], :unique => true
  end

  def self.down
    drop_table :guide_reports
  end
end
