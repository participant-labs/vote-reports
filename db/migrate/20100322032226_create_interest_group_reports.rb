class CreateInterestGroupReports < ActiveRecord::Migration
  def self.up
    create_table :interest_group_reports do |t|
      t.integer :interest_group_id
      t.string :timespan
      t.integer :vote_smart_id

      t.timestamps
    end

    constrain :interest_group_reports do |t|
      t.interest_group_id :reference => {:interest_groups => :id}
    end

    add_index :interest_group_reports, :vote_smart_id, :unique => true
    add_index :interest_group_reports, [:interest_group_id, :timespan], :unique => true
  end

  def self.down
    drop_table :interest_group_reports
  end
end
