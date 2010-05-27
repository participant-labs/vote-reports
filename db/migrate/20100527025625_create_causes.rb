class CreateCauses < ActiveRecord::Migration
  def self.up
    create_table :causes do |t|
      t.string :name, :null => false
      t.text :description, :null => false
      t.string :ancestry

      t.timestamps
    end
  end

  def self.down
    drop_table :causes
  end
end
