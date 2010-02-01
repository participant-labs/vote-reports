namespace :watchdog do
  namespace :zip_codes do
    DATA_PATH = Rails.root.join('data/watchdog/zips/')

    task :download do
      FileUtils.mkdir_p(DATA_PATH)
      Dir.chdir(DATA_PATH) do
        `wget -N http://github.com/aaronsw/watchdog/raw/master/utils/zipdict.txt`
        `wget -N http://github.com/aaronsw/watchdog/raw/master/utils/zip_per_dist.tsv`
      end
    end

    desc "Process Politicians"
    task :unpack => :environment do
      require 'ar-extensions'
      require 'ar-extensions/import/postgresql'
      ActiveRecord::Base.transaction do
        us_states = UsState.all.index_by(&:abbreviation)
        zips = []
        open(DATA_PATH.join('zipdict.txt')).each_line do |line|
          zip, districts = line.split(': ')
          districts.split(' ').each do |district|
            state, district = district.split('-')
            district = District.find_or_create_by_us_state_id_and_district(us_states.fetch(state).id, district || 0)
            zips << [district.id, zip.to_i]
          end
          $stdout.print('.')
          $stdout.flush
        end
        DistrictZipCode.import [:district_id, :zip_code], zips

        zips = []
        open(DATA_PATH.join('zip_per_dist.tsv')).each_line do |line|
          zip, plus_4, district = line.split("\t")
          state, district = district.split('-')
          district = District.find_or_create_by_us_state_id_and_district(us_states.fetch(state).id, district || 0)
          zips << [district.id, zip.to_i, plus_4.to_i]
          $stdout.print('.')
          $stdout.flush
        end
        DistrictZipCode.import [:district_id, :zip_code, :plus_4], zips
      end
    end
  end
end
