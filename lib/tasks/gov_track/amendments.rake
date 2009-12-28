namespace :gov_track do
  namespace :amendments do
    task :unpack => [:'gov_track:support', :'gov_track:politicians'] do
      require 'ar-extensions'
      require 'ar-extensions/import/postgresql'

      existing_amendments = Amendment.all.index_by {|a| "#{meeting}-#{a.chamber}#{a.number}" }
      columns = [
        :bill_id,
        :congress_id,
        :chamber,
        :number,
        :offered_on,
        :sponsor_id,
        :sequence,
        :description,
        :purpose
      ]

      meetings do |meeting|
        puts "Fetching Amendments for Meeting #{meeting}"
        bills = Bill.all(:conditions => {:congress_id => @congress}).index_by {|b| b.gov_track_id }

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

          sponsor = data.at('sponsor')['none'].present? ? nil : @politicians.fetch(data.at('sponsor')['id'].to_i) do
            puts "#{data.at('sponsor').to_s} not found"
            nil
          end
          values = [
            bills.fetch("#{amends['type']}#{@congress.meeting}-#{amends['number']}") do
              raise "#{amends['type']}#{@congress.meeting}-#{amends['number']} not found (#{amends.to_s})"
            end,
            @congress,
            chamber,
            number,
            data.at('offered')['datetime'].to_s,
            sponsor,
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
        Amendment.import_without_validations_or_callbacks columns, new_amendments
        puts
      end
    end
  end
end