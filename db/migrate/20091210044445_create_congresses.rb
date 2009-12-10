class CreateCongresses < ActiveRecord::Migration
  def self.up
    create_table :congresses do |t|
      t.integer :meeting
    end
  end

  def self.down
    drop_table :congresses
  end
end
