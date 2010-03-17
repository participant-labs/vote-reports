class CreateReportFollows < ActiveRecord::Migration
  def self.up
    create_table :report_follows do |t|
      t.integer :user_id, :null => false
      t.integer :report_id, :null => false

      t.timestamps
    end
    constrain :report_follows do |t|
      t.user_id :reference => {:users => :id}
      t.report_id :reference => {:reports => :id}
    end
    add_index :report_follows, :user_id
    add_index :report_follows, :report_id
    add_index :report_follows, [:report_id, :user_id], :unique => true
  end

  def self.down
    drop_table :report_follows
  end
end
