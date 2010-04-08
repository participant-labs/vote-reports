class MoreAppropriateLocationZipCodeDataTypes < ActiveRecord::Migration

  TRUE_WORDS = ['Yes', 'YES']
  FALSE_WORDS = ['No', 'NO']

  def self.up
    add_column :location_zip_codes, :primary_bool, :boolean
    LocationZipCode.update_all({:primary_bool => true}, {:primary => TRUE_WORDS})
    LocationZipCode.update_all({:primary_bool => false}, {:primary => FALSE_WORDS})

    add_column :location_zip_codes, :decommissioned_bool, :boolean
    LocationZipCode.update_all({:decommissioned_bool => true}, {:decommissioned => TRUE_WORDS})
    LocationZipCode.update_all({:decommissioned_bool => false}, {:decommissioned => FALSE_WORDS})
    remove_columns :location_zip_codes, :primary, :decommissioned
    rename_column :location_zip_codes, :primary_bool, :primary
    rename_column :location_zip_codes, :decommissioned_bool, :decommissioned
  end

  def self.down
    raise "foo"
  end
end
