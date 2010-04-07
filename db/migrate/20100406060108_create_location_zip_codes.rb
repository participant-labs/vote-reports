class CreateLocationZipCodes < ActiveRecord::Migration
  def self.up
    create_table :location_zip_codes do |t|
      t.integer :zip_code
      t.float :lat
      t.float :lng
      t.string :city
      t.string :state
      t.string :county
      t.string :country
      t.string :world_region
      t.string :zip_code_type
      t.string :primary
      t.string :location_id
      t.string :location_name
      t.string :population
      t.string :housing_units
      t.string :income
      t.string :land_area
      t.string :water_area
      t.string :decommissioned
      t.string :military_restriction_codes

      t.timestamps
    end
  end

  def self.down
    drop_table :location_zip_codes
  end
end
