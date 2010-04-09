class AssociateLocationsToZipCodes < ActiveRecord::Migration
  class LocationZipCode < ActiveRecord::Base
  end

  class ZipCode < ActiveRecord::Base
  end

  def self.up
    $stdout.sync = true
    add_column :location_zip_codes, :zip_code_id, :integer
    ZipCode.paginated_each(:select => 'id, zip_code') do |zip_code|
      LocationZipCode.update_all({:zip_code_id => zip_code.id}, {:zip_code => zip_code.zip_code})
      $stdout.print '.'
    end
    remove_columns :location_zip_codes, :zip_code, :lat, :lng, :population, :housing_units, :income, :land_area, :water_area, :zip_code_type, :military_restriction_codes, :primary, :decommissioned, :world_region

    change_column :location_zip_codes, :zip_code_id, :integer, :null => false
    constrain :location_zip_codes, :zip_code_id, :reference => {:zip_codes => :id}
    rename_table :location_zip_codes, :locations
  end

  def self.down
    raise "Nope"
  end
end
