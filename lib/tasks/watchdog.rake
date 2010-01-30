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
      missing = {
        110 => {
          'TX-25' => ['78701'],
          'TX-21' => ['78701']
        }
      }
    end
  end
end
