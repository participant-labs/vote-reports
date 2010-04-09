class CreateZipCodes < ActiveRecord::Migration
  def self.up
    create_table :zip_codes do |t|
      t.integer :zip_code, :null => false
      t.float    "lat"
      t.float    "lng"
      t.string   "population"
      t.string   "housing_units"
      t.string   "income"
      t.string   "land_area"
      t.string   "water_area"
      t.string   "zip_code_type"
      t.string   "military_restriction_codes"
      t.boolean   "primary"
      t.boolean   "decommissioned"
      t.string   "world_region" # always NA
    end

    # Leaving for location:
    # t.string   "city"
    # t.string   "state"
    # t.string   "county"
    # t.string   "country"
    # t.string   "location_id"
    # t.string   "location_name"

    add_index :zip_codes, :zip_code, :unique => true
  end

  def self.down
    drop_table :zip_codes
  end
end
