namespace :gov_track do
  namespace :bills do
    def title_columns
      [:title, :title_type, :bill_title_as_id, :bill_id]
    end

    def title_attrs(bill, title_node)
      @bill_title_as ||= BillTitleAs.all(:select => 'bill_title_as.as, id').index_by(&:as)
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
      task :unpack => :'gov_track:support' do
        require 'ar-extensions'
        require 'ar-extensions/import/postgresql'

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
    
    task :unpack => [:'gov_track:support', :'gov_track:politicians'] do
      require 'ar-extensions'
      require 'ar-extensions/import/postgresql'

      @subjects = Subject.all.index_by(&:name)

      meetings do |meeting|
        puts "Fetching Bills for Meeting #{meeting}"

        new_bills = []
        Dir['bills/*'].each do |bill_path|
          @committees = CommitteeMeeting.all(:conditions => {:congress_id => @congress.id}).index_by(&:name)

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
          attrs = {
            :opencongress_id => opencongress_bill_id,
            :gov_track_id => gov_track_bill_id,
            :congress_id => @congress.id,
            :bill_type => data['type'].to_s,
            :bill_number => data['number'].to_s,
            :gov_track_updated_at => data['updated'].to_s,
            :introduced_on => data.at('introduced')['datetime'].to_s,
            :sponsor_id => sponsor && sponsor.id,
            :summary => data.at('summary').inner_text.strip
          }
          if bill = Bill.find_by_opencongress_id(opencongress_bill_id)
            bill.update_attributes!(attrs)
          else
            bill = Bill.create!(attrs)
          end

          new_titles = data.xpath('titles/title').map do |title_node|
            title_attrs(bill, title_node)
          end
          if new_titles.present?
            BillTitle.import_without_validations_or_callbacks title_columns, new_titles
          end

          new_subjects = data.xpath('subjects/term').map do |term_node|
            name = term_node['name'].to_s
            subject = @subjects.fetch(name) do
              @subjects[name] = Subject.create(:name => name)
            end
            [subject.id, bill.id]
          end
          if new_subjects.present?
            BillSubject.import_without_validations_or_callbacks [:subject_id, :bill_id], new_subjects
          end

          new_committee_actions = data.xpath('committees/committee').map do |committee_node|
            committee_name = committee_node['name'].to_s
            committee_meeting_id = find_committee(committee_name, "Bill #{opencongress_bill_id}", committee_node)
            if (subcommittee_name = committee_node['subcommittee']).present?
              subcommittee_id = (committee_meeting_id && CommitteeMeeting.first(
                :joins => :committee, :conditions => {:'committee_meetings.name' => subcommittee_name, :'committees.ancestry' => CommitteeMeeting.find(committee_meeting_id).committee_id.to_s}
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
          end.compact
          if new_committee_actions.present?
            BillCommitteeAction.import_without_validations_or_callbacks [:action, :bill_id, :committee_meeting_id], new_committee_actions
          end

          new_cosponsors = data.xpath('cosponsors/cosponsor').map do |cosponsor_node|
            joined = cosponsor_node['joined'].to_s
            joined = nil if joined.blank?
            [@politicians.fetch(cosponsor_node['id'].to_s.to_i), joined, bill.id]
          end
          if new_cosponsors.present?
            Cosponsorship.import_without_validations_or_callbacks [:politician_id, :joined_on, :bill_id], new_cosponsors
          end

          $stdout.print "."
          $stdout.flush
        end
        puts
      end
      Bill.reindex
    end
  end
end