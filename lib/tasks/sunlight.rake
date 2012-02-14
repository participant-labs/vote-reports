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

    def each_gov_track_politician_row
      require 'csv'

      ActiveRecord::Base.transaction do
        CSV.new(open(SUNLIGHT_POLITICIAN_DATA_PATH), headers: true, skip_blanks: true).each do |row|
          row = row.to_hash.except('senate_class', 'state', 'in_office', 'district', 'party')
          row.delete_if {|k, v| v.blank? }
          row['open_secrets_id'] = row.delete('crp_id')
          yield row
        end
      end
    end

    task scan_for_duplicates: :environment do
      each_gov_track_politician_row do |row|
        p1 = Politician.find_by_gov_track_id(row['govtrack_id'])
        p2 = Politician.find_by_vote_smart_id(row['votesmart_id'])
        if p1 && p2 && p1 != p2
          puts "'#{row['votesmart_id']}' => #{row['govtrack_id']}, # #{p1.name} -> #{p2.name}"
        end
      end
    end

    desc "Process Politicians"
    task unpack: :environment do
      rescue_and_reraise do
        each_gov_track_politician_row do |row|
          pol = Politician.find_by_gov_track_id(row['govtrack_id'])
          if row['phone'].present?
            same_phone_number = Politician.find_by_phone(row['phone'])
            if same_phone_number && pol != same_phone_number
              puts "Moving phone number #{row['phone']} from #{same_phone_number.id} to #{pol.id} from #{row.inspect}"
              same_phone_number.update_attribute(:phone, nil)
            end
          end
          if row['youtube_url'].present?
            same_youtube_url = Politician.find_by_youtube_url(row['youtube_url'])
            if same_youtube_url && pol != same_youtube_url
              puts "Moving youtube url #{row['youtube_url']} from #{same_youtube_url.id} to #{pol.id} from #{row.inspect}"
              same_youtube_url.update_attribute(:youtube_url, nil)
            end
          end
          if row['votesmart_id'] == '26879'
            puts "Skipping vote smart id 26879 for #{row['firstname']} #{row['lastname']} as it's defunct"
            row.delete('votesmart_id')
          end
          begin
            pol.update_attributes!(row)
          rescue => e
            puts "'#{row['votesmart_id']}' => #{row['govtrack_id']}"
            Airbrake.notify(RuntimeError.new("Sunllight error on #{row.inspect}, #{pol.inspect}, #{pol.errors.full_messages.inspect}, #{e.inspect}"))
            raise
          end
          print '.'
        end
        puts
      end
    end
  end
end
