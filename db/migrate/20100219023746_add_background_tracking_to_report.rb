class AddBackgroundTrackingToReport < ActiveRecord::Migration
  def self.up
    create_table :report_delayed_jobs do |t|
      t.integer :report_id, :null => false
      t.integer :delayed_job_id, :null => false
    end
    constrain :report_delayed_jobs do |t|
      t.report_id :reference => {:reports => :id}
      t.delayed_job_id :reference => {:delayed_jobs => :id}
    end
  end

  def self.down
    drop_table :report_delayed_jobs
  end
end
