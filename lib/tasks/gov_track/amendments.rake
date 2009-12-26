namespace :gov_track do
  namespace :amendments do
    task :unpack => [:'gov_track:support', :'gov_track:politicians'] do
      Sunspot.batch do
        ActiveRecord::Base.transaction do
          MEETINGS.each do |meeting|
            Dir.chdir(Rails.root.join("data/gov_track/us/#{meeting}")) do
              puts "Fetching Amendments for Meeting #{meeting}"
              @congress = Congress.find_or_create_by_meeting(meeting)
              Dir['bills.amdt/*'].each do |amendment_path|
                chamber, number = amendment_path.match(%r{bills.amdt/([a-z]+)(\d+)\.xml}).captures

                data =
                  begin
                    Nokogiri::XML(open(amendment_path)).at('amendment')
                  rescue => e
                    puts "#{e.inspect} #{path}"
                    return nil
                  end
                amends = data.at('amends')

                sequence = amends['sequence'].to_s
                sequence = nil if sequence.blank?

                sponsor = data.at('sponsor')['none'].present? ? nil : @politicians.fetch(data.at('sponsor')['id'].to_i) do
                  puts "#{data.at('sponsor').to_s} not found"
                  nil
                end
                bill = Bill.find_by_gov_track_id("#{amends['type']}#{@congress.meeting}-#{amends['number']}")
                Amendment.create!(
                  :bill => bill,
                  :congress => @congress,
                  :chamber => chamber,
                  :number => number,
                  :offered_on => data.at('offered')['datetime'].to_s,
                  :sponsor => sponsor,
                  :sequence => sequence,
                  :description => data.at('description').inner_text,
                  :purpose => data.at('purpose').inner_text
                )

                $stdout.print(sequence.nil? ? 'N' : ".")
                $stdout.flush
              end
              puts
            end
          end
        end
      end
    end
  end
end