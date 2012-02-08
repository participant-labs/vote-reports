namespace :gov_track do
  namespace :amendments do
    task unpack: [:'gov_track:support', :'gov_track:politicians'] do
      amendment_columns = [
        :bill_id,
        :congress_id,
        :chamber,
        :number,
        :short_name,
        :offered_on,
        :sponsor_id,
        :sponsor_type,
        :sequence,
        :description,
        :purpose
      ]

      meetings do |meeting|
        puts "Fetching Amendments for Meeting #{meeting}"
        existing_amendments = @congress.amendments.index_by {|a| "#{meeting}-#{a.chamber}#{a.number}" }
        bills = @congress.bills.index_by {|b| b.gov_track_id }

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

          bill = bills.fetch("#{amends['type']}#{@congress.meeting}-#{amends['number']}") do
            notify_airbrake("#{amends['type']}#{@congress.meeting}-#{amends['number']} not found (#{amends.to_s})")
          end || begin
            $stdout.print('-')
            next
          end

          values = [
            bill.id,
            @congress.id,
            chamber,
            number,
            "#{chamber}-#{number}",
            data.at('offered')['datetime'].to_s,
            sponsor && sponsor.id,
            sponsor && sponsor.class.name,
            sequence,
            data.at('description').inner_text,
            data.at('purpose').inner_text
          ]

          if amendment = existing_amendments["#{meeting}-#{chamber}#{number}"]
            amendment.update_attributes!(Hash[amendment_columns.zip(values)])
          else
            new_amendments << values
          end

          $stdout.print(amendment.nil? ? '.' : "*")
          $stdout.flush
        end
        if new_amendments.present?
          Amendment.import_without_validations_or_callbacks amendment_columns, new_amendments
        end
        puts
        raise "Import failed (#{Amendment.count} not at least #{new_amendments.size})" if Amendment.count < new_amendments.size
      end
    end
  end
end