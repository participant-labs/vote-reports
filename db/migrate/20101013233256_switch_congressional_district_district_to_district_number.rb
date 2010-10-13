class SwitchCongressionalDistrictDistrictToDistrictNumber < ActiveRecord::Migration
  def self.up
    rename_column :congressional_districts, :district, :district_number
  end

  def self.down
    rename_column :congressional_districts, :district_number, :district
  end
end
