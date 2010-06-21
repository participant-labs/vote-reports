class PoliticianDistrictIsCongressional < ActiveRecord::Migration
  def self.up
    rename_column :politicians, :district_id, :congressional_district_id
  end

  def self.down
    rename_column :politicians, :congressional_district_id, :district_id
  end
end
