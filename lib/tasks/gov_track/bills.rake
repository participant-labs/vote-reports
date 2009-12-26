namespace :gov_track do
  namespace :bills do
    task :unpack => [:'gov_track:support', :'gov_track:politicians'] do
      existing_bills = Bill.all.index_by {|b| b.opencongress_id }
      Sunspot.batch do
        ActiveRecord::Base.transaction do
          MEETINGS.each do |meeting|
            Dir.chdir(Rails.root.join("data/gov_track/us/#{meeting}")) do
              puts "Fetching Bills for Meeting #{meeting}"
              @congress = Congress.find_or_create_by_meeting(meeting)
              Dir['bills/*'].each do |bill_path|
                type, number = bill_path.match(%r{bills/([a-z]+)(\d+)\.xml}).captures
                opencongress_bill_id = "#{meeting}-#{type}#{number}"
                gov_track_bill_id = "#{type}#{meeting}-#{number}"

                (existing_bills[opencongress_bill_id] \
                  || Bill.new(:opencongress_id => opencongress_bill_id)).tap do |bill|
                  data =
                    begin
                      Nokogiri::XML(open(bill_path)).at('bill')
                    rescue => e
                      puts "#{e.inspect} #{bill_path}"
                      return nil
                    end
                  raise "Something is weird #{@congress.meeting} != #{data['session']}" if @congress.meeting != data['session'].to_i
                  sponsor = data.at('sponsor')['none'].present? ? nil : @politicians.fetch(data.at('sponsor')['id'].to_i)
                  bill.update_attributes!(
                    :gov_track_id => gov_track_bill_id,
                    :congress => @congress,
                    :title => data.css('titles > title[type=official]').inner_text,
                    :bill_type => data['type'].to_s,
                    :bill_number => data['number'].to_s,
                    :updated_at => data['updated'].to_s,
                    :introduced_on => data.at('introduced')['datetime'].to_s,
                    :sponsor => sponsor,
                    :summary => data.at('summary').inner_text.strip,
                    :congress => @congress
                  )

                  $stdout.print "."
                  $stdout.flush
                end
              end
              puts
            end
          end
        end
      end
    end
  end
end