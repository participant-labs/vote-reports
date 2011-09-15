namespace :gov_track do
  namespace :committees do

    desc "Process Committess"
    task unpack: [:support, :politicians] do
      def import_committee(committee, node)
        committee.update_attributes!(
          :display_name => node['displayname'].to_s
        )
        if meeting_name = node['thomasname']
          committee.meetings.find_by_congress_id(@congress.id) \
           || committee.meetings.create!(name: meeting_name.to_s, :congress_id => @congress.id)
        end
        node.xpath('thomas-names/name').each do |name_node|
          committee.meetings.find_or_create_by_congress_id(
            Congress.find_or_create_by_meeting(name_node['session'].to_s.to_i).id
          ).update_attribute(:name, name_node.inner_text)
        end
        node.xpath('member').each do |member_node|
          meeting = committee.meetings.find_or_create_by_congress_id(@congress.id)
          raise meeting.errors.full_messages.inspect if meeting.new_record?
          membership = meeting.memberships.find_or_create_by_politician_id(
              politician(member_node['id'].to_s).id
            )
          membership.update_attribute(:role, member_node['role'].to_s)
          raise membership.errors.full_messages.inspect if membership.new_record?
        end
      end

      def import_committee_node(committee_node)
        committee = Committee.find_by_code(committee_node['code'].to_s) || Committee.new(code: committee_node['code'].to_s)
        import_committee(committee, committee_node)
        $stdout.print "C"
        $stdout.flush
        committee_node.xpath('subcommittee').each do |subcommittee_node|
          subcommittee = committee.children.find_by_code(subcommittee_node['code'].to_s) || Committee.new(parent: committee, code: subcommittee_node['code'].to_s)
          import_committee(subcommittee, subcommittee_node)
          subcommittee_node.xpath('subcommittee').each do |subsubcommittee_node|
            raise "Subsub #{subsubcommittee_node}"
          end
          $stdout.print "."
          $stdout.flush
        end
      end

      rescue_and_reraise do
        puts "All"
        doc =
          begin
            Nokogiri::XML(open(Rails.root.join('data/gov_track/us/committees.xml')))
          rescue => e
            puts e.inspect
            next
          end
        doc.xpath('committees/committee').each do |committee_node|
          import_committee_node(committee_node)
        end

        meetings do |meeting|
          puts "Meeting #{meeting}"
          doc =
            begin
              Nokogiri::XML(open(Rails.root.join('data/gov_track/us', meeting.to_s, 'committees.xml')))
            rescue => e
              puts e.inspect
              next
            end
          doc.xpath('committees/committee').each do |committee_node|
            import_committee_node(committee_node)
          end
          puts "\n\n"
        end
      end
    end
  end
end