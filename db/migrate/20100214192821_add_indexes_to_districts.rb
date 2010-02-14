class AddIndexesToDistricts < ActiveRecord::Migration
  def self.up
    add_index :districts, :us_state_id
    add_index :district_zip_codes, :district_id
    add_index :district_zip_codes, :zip_code
    add_index :district_zip_codes, [:zip_code, :plus_4]
  end

  def self.down
  end
end
