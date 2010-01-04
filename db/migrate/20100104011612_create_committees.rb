class CreateCommittees < ActiveRecord::Migration
  def self.up
    create_table :committees do |t|
      t.string :chamber
      t.string :code, :null => false
      t.string :name, :null => false
      t.string :thomas_name
      t.string :ancestry

      t.timestamps
    end
    constrain :committees do |t|
      t.code :not_blank => true, :unique => true
      t.name :not_blank => true
    end
    add_index :committees, :ancestry
  end

  def self.down
    drop_table :committees
  end
end
