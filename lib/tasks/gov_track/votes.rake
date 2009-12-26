namespace :gov_track do
  namespace :votes do

    desc "Process Votes"
    task :unpack => [:support, :politicians] do
      meetings do |meeting|
        puts "Meeting #{meeting}"
        Dir['rolls/*'].each do |roll_path|
          gov_track_roll_id = roll_path.match(%r{rolls/(.+)\.xml}).captures.first

          Roll.find_by_gov_track_id(gov_track_roll_id) || begin
            data = Nokogiri::XML(open(gov_track_path("us/#{@congress.meeting}/rolls/#{gov_track_roll_id}.xml"))).at('roll')
            subject =
              if bill = data.at('bill')
                bill = Bill.find_by_gov_track_id("#{bill['type']}#{bill['session']}-#{bill['number']}")
                if bill.nil?
                  puts "#{data.at('bill')} not found"
                  next
                end
                if amendment = data.at('amendment')
                  p amendment['ref'].to_s if amendment['ref'].to_s != 'bill-serial'
                  bill.amendments.find_by_sequence(amendment['number']).tap do |amendment|
                    if amendment.nil?
                      puts "#{data.at('amendment')} for #{data.at('bill')} not found"
                      next
                    end
                  end
                else
                  bill
                end
              end
            next if subject.nil?
            roll = Roll.create(
              :gov_track_id => gov_track_roll_id,
              :subject => subject,
              :congress => @congress,
              :where => data['where'].to_s,
              :voted_at => data['datetime'].to_s,
              :aye => data['aye'].to_s,
              :nay => data['nay'].to_s,
              :not_voting => data['nv'].to_s,
              :present => data['present'].to_s,
              :result => data.at('result').inner_text,
              :required => data.at('required').inner_text,
              :question => data.at('question').inner_text,
              :roll_type => data.at('type').inner_text,
              :congress => @congress
            )
            inserts = data.xpath('voter').map { |vote|
              voter = @politicians[vote['id'].to_i]
              if voter.nil?
                puts "Ignoring #{vote.inspect}"
                next
              end
              ["'#{vote['vote']}'", voter.id, roll.id].join(', ')
            }.compact.join("), (")
            ActiveRecord::Base.connection.execute(%{
              INSERT INTO "votes" (vote, politician_id, roll_id) VALUES
                (#{ inserts });
            })
          end

          $stdout.print "."
          $stdout.flush
        end
        puts
      end
    end

  end
end
