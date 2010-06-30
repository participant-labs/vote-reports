class CreateGuides < ActiveRecord::Migration
  def self.up
    create_table :guides do |t|
      t.integer :congressional_district_id
      t.integer :zip_code_id
      t.integer :plus_4
      t.integer :report_id
      t.integer :user_id

      t.timestamps
    end
    constrain :guides do |t|
      t.congressional_district_id :reference => {:congressional_districts => :id}
      t.zip_code_id :reference => {:zip_codes => :id}
      t.report_id :reference => {:reports => :id}
      t.user_id :reference => {:users => :id}
    end
    [:congressional_district_id, :zip_code_id, :user_id].each do |field|
      add_index :guides, field
    end
    add_index :guides, :report_id, :unique => true
  end

  def self.down
    drop_table :guides
  end
end
