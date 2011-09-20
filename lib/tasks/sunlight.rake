namespace :sunlight do
  namespace :politicians do
    SUNLIGHT_POLITICIAN_DATA_PATH = Rails.root.join('data/sunlight_labs/legislators/legislators.csv')

    desc "download sunlight data"
    task :download do
      FileUtils.mkdir_p(SUNLIGHT_POLITICIAN_DATA_PATH.dirname)
      log = Rails.root.join('log/sunlight-rsync.log')
      Dir.chdir(SUNLIGHT_POLITICIAN_DATA_PATH.dirname) do
        `wget -N http://github.com/Empact/sunlight-labs-api-data/raw/master/legislators/legislators.csv --append-output=#{log}`
      end
    end

    desc "Process Politicians"
    task unpack: :environment do
      rescue_and_reraise do
        require 'fastercsv'
        require 'open-uri'

        ActiveRecord::Base.transaction do
          FasterCSV.new(open(SUNLIGHT_POLITICIAN_DATA_PATH), headers: true, skip_blanks: true).each do |row|
            row = row.to_hash.except('senate_class', 'state', 'in_office', 'district', 'party')
            row.delete_if {|k, v| v.blank? }
            begin
              Politician.find_by_gov_track_id(row['govtrack_id']).update_attributes!(row)
            rescue
              notify_hoptoad("Sunllight error on #{row.inspect}")
              raise
            end
          end
        end
      end
    end
  end
end
