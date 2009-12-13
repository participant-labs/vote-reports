require 'fastercsv'
require 'open-uri'

namespace :sunlight do
  namespace :politicians do
    desc "Process Politicians"
    task :unpack => :environment do
      def data_path
        data_path = Rails.root.join('data/sunlight_labs/legislators/legislators.csv')
        data_path.exist? ? data_papth : 'http://github.com/Empact/sunlight-labs-api-data/raw/master/legislators/legislators.csv'
      end

      ActiveRecord::Base.transaction do
        FasterCSV.new(open(data_path), :headers => true, :skip_blanks => true).each do |row|
          row = row.to_hash.except('senate_class')
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
