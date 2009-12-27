namespace :gov_track do
  namespace :bills do
    task :unpack => [:'gov_track:support', :'gov_track:politicians'] do
      require 'ar-extensions'
      require 'ar-extensions/import/postgresql'

      existing_bills = Bill.all.index_by {|b| b.opencongress_id }
      columns = [
        :opencongress_id,
        :gov_track_id,
        :congress_id,
        :title,
        :bill_type,
        :bill_number,
        :updated_at,
        :introduced_on,
        :sponsor_id,
        :summary
      ]
      meetings do |meeting|
        puts "Fetching Bills for Meeting #{meeting}"
        new_bills = []
        Dir['bills/*'].each do |bill_path|
          type, number = bill_path.match(%r{bills/([a-z]+)(\d+)\.xml}).captures
          opencongress_bill_id = "#{meeting}-#{type}#{number}"
          gov_track_bill_id = "#{type}#{meeting}-#{number}"

          data =
            begin
              Nokogiri::XML(open(bill_path)).at('bill')
            rescue => e
              puts "#{e.inspect} #{bill_path}"
              return nil
            end
          raise "Something is weird #{@congress.meeting} != #{data['session']}" if @congress.meeting != data['session'].to_i
          sponsor = data.at('sponsor')['none'].present? ? nil : @politicians.fetch(data.at('sponsor')['id'].to_i)
          values = [
            opencongress_bill_id,
            gov_track_bill_id,
            @congress,
            data.css('titles > title[type=official]').inner_text,
            data['type'].to_s,
            data['number'].to_s,
            data['updated'].to_s,
            data.at('introduced')['datetime'].to_s,
            sponsor,
            data.at('summary').inner_text.strip
          ]
          if bill = existing_bills[opencongress_bill_id]
            bill.update_attributes!(Hash[columns.zip(values)])
          else
            new_bills << values
          end

          $stdout.print "."
          $stdout.flush
        end
        Bill.import columns, new_bills
        puts
      end
    end
  end
end