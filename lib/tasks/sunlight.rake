require 'fastercsv'

namespace :sunlight do
  namespace :politicians do
    desc "Process Politicians"
    task :unpack => :environment do
      ActiveRecord::Base.transaction do
        data_path = Rails.root.join('data/sunlight_labs/legislators/legislators.csv')
        FasterCSV.foreach(data_path, :headers => true, :skip_blanks => true) do |row|
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
