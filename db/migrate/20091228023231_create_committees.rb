class CreateCommittees < ActiveRecord::Migration
  def self.up
    create_table :committees do |t|
      t.string :chamber
      t.string :code, :null => false
      t.string :display_name, :null => false
      t.string :ancestry

      t.timestamps
    end
    constrain :committees do |t|
      t.code :not_blank => true
      t.name :not_blank => true
      t[:code, :ancestry].all :unique => true
    end
    add_index :committees, :ancestry

    create_table :committee_meetings do |t|
      t.string :name, :null => false
      t.integer :congress_id, :null => false
      t.integer :committee_id, :null => false

      t.timestamps
    end
    constrain :committee_meetings do |t|
      t.name :not_blank => true
      t.congress_id :reference => {:congresses => :id, :on_delete => :cascade}
      t.committee_id :reference => {:committees => :id, :on_delete => :cascade}
      t[:congress_id, :committee_id].all :unique => true
    end
  end

  def self.down
    transaction do
      drop_table :committee_meetings
      drop_table :committees
    end
  end
end
