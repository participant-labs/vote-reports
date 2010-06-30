class DistrictsAreCongressionalDistricts < ActiveRecord::Migration
  def self.up
    rename_table :districts, :congressional_districts
    rename_table :district_zip_codes, :congressional_district_zip_codes

    rename_column :congressional_district_zip_codes, :district_id, :congressional_district_id
    rename_column :representative_terms, :district_id, :congressional_district_id
  end

  def self.down
    rename_column :congressional_district_zip_codes, :congressional_district_id, :district_id
    rename_column :representative_terms, :congressional_district_id, :district_id

    rename_table :congressional_districts, :districts
    rename_table :congressional_district_zip_codes, :district_zip_codes
  end
end
