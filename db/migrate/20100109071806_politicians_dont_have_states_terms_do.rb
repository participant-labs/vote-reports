class PoliticiansDontHaveStatesTermsDo < ActiveRecord::Migration
  def self.up
    remove_column :politicians, :state
  end

  def self.down
    add_column :politicians, :state, :string
  end
end
