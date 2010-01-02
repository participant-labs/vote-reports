class CreateParties < ActiveRecord::Migration
  def self.up
    create_table :parties do |t|
      t.string :name, :null => false

      t.timestamps
    end
    constrain :parties do |t|
      t.name :not_blank => true
    end
  end

  def self.down
    drop_table :parties
  end
end
