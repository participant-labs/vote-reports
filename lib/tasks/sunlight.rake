require 'fastercsv'
require 'open-uri'

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
      ActiveRecord::Base.transaction do
        FasterCSV.new(open(DATA_PATH), :headers => true, :skip_blanks => true).each do |row|
          row = row.to_hash.except('senate_class', 'state')
          begin
            politician = Politician.first(:conditions => {:bioguide_id => row['bioguide_id']})
            politician ? politician.update_attributes!(row) : Politician.create!(row)
          rescue => e
            notify_exceptional(e)
            p row
            raise
          end
        end
      end
    end
  end
end
