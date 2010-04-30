namespace :gov_track do
  namespace :amendments do
    task :unpack => [:'gov_track:support', :'gov_track:politicians'] do
      require 'ar-extensions'
      require 'ar-extensions/import/postgresql'

      meetings do |meeting|
        existing_amendments = @congress.amendments.index_by {|a| "#{meeting}-#{a.chamber}#{a.number}" }

        puts "Fetching Amendments for Meeting #{meeting}"
        bills = Bill.all(:conditions => {:congress_id => @congress}).index_by {|b| b.gov_track_id }
        @committee_meetings = CommitteeMeeting.all(:conditions => {:congress_id => @congress.id}).index_by(&:name)

        new_amendments = []
        Dir['bills.amdt/*.xml'].each do |amendment_path|
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

          sponsor =
            if data.at('sponsor')['none'].present?
              nil
            elsif sponsor_committee_name = data.at('sponsor')['committee']
              find_committee(sponsor_committee_name.to_s, "Amendment #{meeting}-#{chamber}#{number}", data.at('sponsor')) || begin
                puts "Committee from #{data.at('sponsor').to_s} not found for #{amendment_path}"
                nil
              end
            elsif sponsor_politician_id = data.at('sponsor')['id']
               @politicians.fetch(sponsor_politician_id.to_i) do
                 puts "Politician from #{data.at('sponsor').to_s} not found for #{amendment_path}"
                 nil
               end
             else
               puts "#{data.at('sponsor').to_s} not found"
               nil
             end

          values = [
            bills.fetch("#{amends['type']}#{@congress.meeting}-#{amends['number']}") do
              raise "#{amends['type']}#{@congress.meeting}-#{amends['number']} not found (#{amends.to_s})"
            end.id,
            @congress.id,
            chamber,
            number,
            data.at('offered')['datetime'].to_s,
            sponsor && sponsor.id,
            sponsor && sponsor.class.name,
            sequence,
            data.at('description').inner_text,
            data.at('purpose').inner_text
          ]

          if amendment = existing_amendments["#{meeting}-#{chamber}#{number}"]
            amendment.update_attributes!(Hash[columns.zip(values)])
          else
            new_amendments << values
          end

          $stdout.print(sequence.nil? ? 'N' : ".")
          $stdout.flush
        end
        columns = [
          :bill_id,
          :congress_id,
          :chamber,
          :number,
          :offered_on,
          :sponsor_id,
          :sponsor_type,
          :sequence,
          :description,
          :purpose
        ]
        Amendment.import_without_validations_or_callbacks columns, new_amendments
        puts
        raise "Import failed (#{Amendment.count} not at least #{new_amendments.size})" if Amendment.count < new_amendments.size
      end
    end
  end
end