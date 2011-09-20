namespace :gov_track do
  namespace :bills do
    def update?
      !ENV['FRESH']
    end

    def import(model, columns, new_instances)
      if update?
        new_instances.map {|i| Hash[columns.zip(i)] }.each do |new_instance|
          model.exists?(new_instance) || model.create!(new_instance)
        end
      elsif new_instances.present?
        model.import_without_validations_or_callbacks columns, new_instances
      end
    end

    def title_columns
      [:title, :title_type, :bill_title_as_id, :bill_id]
    end

    def title_attrs(bill, title_node)
      @bill_title_as ||= BillTitleAs.all(select: 'bill_title_as.as, id').index_by(&:as)
      as = title_node['as'].to_s
      type = title_node['type'].to_s
      if type == 'popular'
        as = 'popular'
        type = 'short'
      end
      as = @bill_title_as.fetch(as)
      [title_node.inner_text, type, as.id, bill.id]
    end

    namespace :titles do
      task unpack: :'gov_track:support' do
        ActiveRecord::Base.transaction do
          BillTitle.delete_all
          meetings do |meeting|
            puts "Loading bill titles for meeting: #{meeting}"

            new_titles = @congress.bills.inject([]) do |new_titles, bill|
              bill_path = Rails.root.join('data/gov_track/us', @congress.meeting.to_s, 'bills', "#{bill.ref}.xml")
              titles =
                begin
                  Nokogiri::XML(open(bill_path)).xpath('bill/titles/title')
                rescue => e
                  puts "#{e.inspect} #{bill_path}"
                  next
                end
              $stdout.print '.'
              $stdout.flush
              new_titles + titles.map do |title_node|
                title_attrs(bill, title_node)
              end
            end
            if new_titles.present?
              BillTitle.import_without_validations_or_callbacks title_columns, new_titles
            end
            puts
          end
        end
        
      end
    end

    task unpack: [:'gov_track:support', :'gov_track:politicians'] do
      rescue_and_reraise do
        @subjects = Subject.all.index_by(&:name)

        if ENV['MEETING'] == 'ALL'
          ENV['MEETING'] = ''
        elsif ENV['MEETING'].blank?
          ENV['MEETING'] = '111'
        end

        meetings do |meeting|
          puts "Fetching Bills for Meeting #{meeting}"

          new_bills = []
          bills = Dir['bills/*'].map do |bill_path|
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
            if @congress.meeting != data['session'].to_i
              raise "Something is weird #{@congress.meeting} != #{data['session']}" 
            end
            sponsor = @politicians.fetch(data.at('sponsor')['id'].to_i) unless data.at('sponsor')['none'].present?
            introduced_on = data.at('introduced')['datetime'].to_s
            attrs = {
              opencongress_id: opencongress_bill_id,
              gov_track_id: gov_track_bill_id,
              congress_id: @congress.id,
              bill_type: data['type'].to_s,
              bill_number: data['number'].to_s,
              gov_track_updated_at: data['updated'].to_s,
              introduced_on: introduced_on,
              summary: data.at('summary').inner_text.strip
            }
            if update? && bill = Bill.find_by_opencongress_id(opencongress_bill_id)
              bill.update_attributes!(attrs)
            else
              bill = Bill.create!(attrs)
            end

            import(BillTitle, title_columns, data.xpath('titles/title').map do |title_node|
              title_attrs(bill, title_node)
            end)

            import(BillSubject, [:subject_id, :bill_id],
            data.xpath('subjects/term').map do |term_node|
              name = term_node['name'].to_s
              subject = @subjects.fetch(name) do
                @subjects[name] = Subject.create(name: name)
              end
              [subject.id, bill.id]
            end)

            import(BillCommitteeAction, [:action, :bill_id, :committee_meeting_id],
            data.xpath('committees/committee').map do |committee_node|
              committee_name = committee_node['name'].to_s
              committee_meeting_id = find_committee(committee_name, "Bill #{opencongress_bill_id}", committee_node)
              if (subcommittee_name = committee_node['subcommittee']).present?
                subcommittee_id = (committee_meeting_id && CommitteeMeeting.first(
                  joins: :committee, conditions: {:'committee_meetings.name' => subcommittee_name, :'committees.ancestry' => CommitteeMeeting.find(committee_meeting_id).committee_id.to_s}
                ).try(:id)) || find_subcommittee(committee_name, subcommittee_name, "Bill #{opencongress_bill_id}", committee_node)
                committee_meeting_id = subcommittee_id if subcommittee_id
              end
              if committee_meeting_id.nil?
                if committee_node['name'].to_s != "House Administration"
                  puts
                  p committee_node
                end
                next
              end
              [committee_node['activity'].to_s, bill.id, committee_meeting_id]
            end.compact)

            import(Cosponsorship, [:politician_id, :joined_on, :bill_id],
            data.xpath('cosponsors/cosponsor').map do |cosponsor_node|
              joined = cosponsor_node['joined'].to_s
              joined = nil if joined.blank?
              [@politicians.fetch(cosponsor_node['id'].to_s.to_i).id, joined, bill.id]
            end)
            if sponsor
              sponsorship = Cosponsorship.create!(bill: bill, politician: sponsor, joined_on: introduced_on)
              bill.update_attribute(:sponsorship_id, sponsorship.id)
            end

            $stdout.print "."
            $stdout.flush
            bill
          end
          puts "Reindexing"
          Sunspot.index!(bills)
          puts
        end
      end
    end
  end
end