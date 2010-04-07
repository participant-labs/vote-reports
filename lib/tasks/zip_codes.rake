namespace :zip_codes do
  DATA_PATH = Rails.root.join('data/federalgovernmentzipcodes.us/free-zipcode-database.csv')

  task :download do
    FileUtils.mkdir_p(DATA_PATH.dirname)
    Dir.chdir(DATA_PATH.dirname) do
      `wget -N http://federalgovernmentzipcodes.us/free-zipcode-database.csv`
    end
  end

  task :import => :environment do
    require 'ar-extensions'
    require 'ar-extensions/import/postgresql'
    require 'faster_csv'
    require 'open-uri'

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

    ActiveRecord::Base.transaction do
      rows = FasterCSV.read(DATA_PATH, :headers => true, :skip_blanks => true).to_a
      headers = rows.shift
      raise [IN_COLS, headers] if IN_COLS != headers
      LocationZipCode.import_without_validations_or_callbacks(OUT_COLS, rows)
    end
  end
end
