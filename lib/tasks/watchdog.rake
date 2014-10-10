namespace :watchdog do
  namespace :zip_codes do
    WATCHDOG_ZIP_CODES_DATA_PATH = Rails.root.join('data/watchdog/zips/')

    task :download do
      FileUtils.mkdir_p(WATCHDOG_ZIP_CODES_DATA_PATH)
      log = Rails.root.join('log/sunlight-data.log')
      Dir.chdir(WATCHDOG_ZIP_CODES_DATA_PATH) do
        `wget -N http://github.com/aaronsw/watchdog/raw/master/utils/zipdict.txt --append-output=#{log}`
        `wget -N http://github.com/aaronsw/watchdog/raw/master/utils/zip_per_dist.tsv --append-output=#{log}`
      end
    end

    desc "Process Politicians"
    task unpack: :environment do
      ActiveRecord::Base.transaction do
        us_states = UsState.all.index_by(&:abbreviation)
        zips = []
        open(WATCHDOG_ZIP_CODES_DATA_PATH.join('zipdict.txt')).each_line do |line|
          zip, districts = line.split(': ')
          districts.split(' ').each do |district|
            district = 'NE-02' if district == 'NE-99'
            state, district = district.split('-')
            district = CongressionalDistrict.find_or_create_by(us_state_id: us_states.fetch(state).id, district_number: district || 0)
            zips << [district.id, zip.to_i]
          end
          $stdout.print('.')
          $stdout.flush
        end
        CongressionalDistrictZipCode.import [:congressional_district_id, :zip_code], zips

        zips = []
        open(WATCHDOG_ZIP_CODES_DATA_PATH.join('zip_per_dist.tsv')).each_line do |line|
          zip, plus_4, district = line.split("\t")
          state, district = district.split('-')
          district = CongressionalDistrict.find_or_create_by(us_state_id: us_states.fetch(state).id, district_number: district || 0)
          zips << [district.id, zip.to_i, plus_4.to_i]
          $stdout.print('.')
          $stdout.flush
        end
        CongressionalDistrictZipCode.import [:district_id, :zip_code, :plus_4], zips
      end
    end
  end
end
