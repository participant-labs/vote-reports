class PopulateZipCodes < ActiveRecord::Migration
  class LocationZipCode < ActiveRecord::Base
  end

  class ZipCode < ActiveRecord::Base
  end

  def self.up
    $stdout.sync = true
    raise "Missing Locations" if LocationZipCode.count == 0
    LocationZipCode.all(:select => 'DISTINCT zip_code').each do |zip_code|
      ZipCode.create(LocationZipCode.first(:conditions => {:zip_code => zip_code.zip_code}, :select => 'zip_code, lat, lng, population, housing_units, income, land_area, water_area, zip_code_type, military_restriction_codes, location_zip_codes.primary, decommissioned, world_region').attributes)
      $stdout.print '.'
    end
  end

  def self.down
  end
end
