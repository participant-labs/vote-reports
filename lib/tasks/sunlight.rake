namespace :sunlight do
  namespace :politicians do
    SUNLIGHT_POLITICIAN_DATA_PATH = Rails.root.join('data/sunlight_labs/legislators/legislators.csv')

    desc "download sunlight data"
    task :download do
      FileUtils.mkdir_p(SUNLIGHT_POLITICIAN_DATA_PATH.dirname)
      Dir.chdir(SUNLIGHT_POLITICIAN_DATA_PATH.dirname) do
        `wget -N http://github.com/Empact/sunlight-labs-api-data/raw/master/legislators/legislators.csv`
      end
    end

    desc "Process Politicians"
    task :unpack => :environment do
      Exceptional.rescue_and_reraise do
        require 'fastercsv'
        require 'open-uri'

        ActiveRecord::Base.transaction do
          FasterCSV.new(open(SUNLIGHT_POLITICIAN_DATA_PATH), :headers => true, :skip_blanks => true).each do |row|
            row = row.to_hash.except('senate_class', 'state', 'in_office', 'district', 'party')
            row.keys.each do |field|
              row.delete(field) if row[field].blank?
            end
            Politician.find_by_gov_track_id(row['govtrack_id']).update_attributes!(row)
          end
        end
      end
    end
  end
end
