class RequireIntroducedOnForBills < ActiveRecord::Migration
  def self.up
    change_table :bills do |t|
      t.change :introduced_on, :date, :null => false
    end
  end

  def self.down
    change_table :bills do |t|
      t.change :introduced_on, :date, :null => true
    end
  end
end
