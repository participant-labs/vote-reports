namespace :zip_codes do
  DATA_PATH = Rails.root.join('data/federalgovernmentzipcodes.us/free-zipcode-database.csv')

  task :download do
    FileUtils.mkdir_p(DATA_PATH.dirname)
    log = Rails.root.join('log/zip-code-data.log')
    Dir.chdir(DATA_PATH.dirname) do
      `wget -N http://federalgovernmentzipcodes.us/free-zipcode-database.csv --append-output=#{log}`
    end
  end

  task import: :environment do
    require 'open-uri'
    require 'excelsior'

    IN_COLS = [
      "Zipcode",
      "Lat",
      "Long",
      "City",
      "State",
      "County",
      "Type",
      "Primary",
      "WorldRegion",
      "Country",
      "LocationText",
      "Location",
      "Population",
      "HousingUnits",
      "Income",
      "LandArea",
      "WaterArea",
      "Decommisioned",
      "MilitaryRestrictionCodes"
    ]

    OUT_COLS = [
      'zip_code',
      'lat',
      'lng',
      'city',
      'state',
      'county',
      'zip_code_type',
      'primary',
      'world_region',
      'country',
      'location_name',
      'location_id',  
      'population',
      'housing_units',
      'income',
      'land_area',
      'water_area',
      'decommissioned',
      'military_restriction_codes'
    ].freeze

    class LocationZipCode < ActiveRecord::Base
    end

    ActiveRecord::Base.transaction do
      $stdout.sync = true
      count = 0
      rows = []
      Excelsior::Reader.rows(File.open(DATA_PATH, 'rb')) do |row|
       rows << row
       if count == 0
         headers = rows.shift
         raise [IN_COLS, headers] if IN_COLS != headers
       end
       count += 1
       if count % 300 == 0
         puts "Importing"
         LocationZipCode.import_without_validations_or_callbacks(OUT_COLS, rows)
         rows = []
       end
       $stdout.print '.'
      end
      if rows.present?
        puts "Importing"
        LocationZipCode.import_without_validations_or_callbacks(OUT_COLS, rows)
      end
    end
  end
end
