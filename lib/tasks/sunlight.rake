namespace :sunlight do
  namespace :politicians do
    DATA_PATH = Rails.root.join('data/sunlight_labs/legislators/legislators.csv')

    task :download do
      FileUtils.mkdir_p(DATA_PATH.dirname)
      Dir.chdir(DATA_PATH.dirname) do
        `wget -N http://github.com/Empact/sunlight-labs-api-data/raw/master/legislators/legislators.csv`
      end
    end

    desc "Process Politicians"
    task :unpack => :environment do
      Exceptional.rescue_and_reraise do
        require 'fastercsv'
        require 'open-uri'

        ActiveRecord::Base.transaction do
          FasterCSV.new(open(DATA_PATH), :headers => true, :skip_blanks => true).each do |row|
            row = row.to_hash.except('senate_class', 'state')
            Politician.first(:conditions => {:gov_track_id => row['govtrack_id']}).update_attributes!(row)
          end
        end
      end
    end
  end
end
