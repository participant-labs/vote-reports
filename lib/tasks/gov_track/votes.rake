namespace :gov_track do
  namespace :votes do

    desc "Process Votes"
    task :unpack => [:support, :politicians] do
      require 'ar-extensions'
      require 'ar-extensions/import/postgresql'

      meetings do |meeting|
        existing_rolls = @congress.rolls.index_by {|r| "#{r.where.first}#{r.year}-#{r.number}"}
        puts "Meeting #{meeting}"
        Dir['rolls/*'].each do |roll_path|
          where, year, number = roll_path.match(%r{rolls/(.)(\d+)-(\d+)\.xml}).captures
          next if existing_rolls["#{r.where}#{r.year}-#{r.number}"]

          data = Nokogiri::XML(open(gov_track_path("us/#{@congress.meeting}/rolls/#{where}#{year}-#{number}.xml"))).at('roll')
          subject =
            if bill = data.at('bill')
              bill = Bill.find_by_gov_track_id("#{bill['type']}#{bill['session']}-#{bill['number']}")
              if bill.nil?
                puts "#{data.at('bill')} not found"
                next
              end
              if amendment = data.at('amendment')
                case amendment['ref'].to_s
                when 'bill-serial'
                  bill.amendments.find_by_sequence(amendment['number'])
                when 'regular'
                  chamber, number = amendment['number'].match(/(.*?)(\d+)/).captures
                  Amendment.find_by_congress_id_and_chamber_and_number(@congress.id, chamber, number.to_i)
                else
                  raise amendment.inspect
                end.tap do |amendment|
                  puts "#{data.at('amendment')} for #{data.at('bill')} not found" if amendment.nil?
                end
              else
                bill
              end
            end
          next if subject.nil?
          roll = Roll.create(
            :year => year,
            :number => number,
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
            [vote['vote'], voter.id, roll.id]
          }.compact

          Vote.import_without_validations_or_callbacks [:vote, :politician_id, :roll_id], inserts

          $stdout.print "."
          $stdout.flush
        end
        puts "\n"
      end
      `rake db:migrate:redo VERSION=20100116015937`
    end

  end
end
