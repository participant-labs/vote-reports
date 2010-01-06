namespace :gov_track do
  namespace :committees do

    desc "Process Committess"
    task :unpack => [:support, :politicians] do
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
          committee = Committee.find_by_code(committee_node['code'].to_s) || Committee.new(:code => committee_node['code'].to_s)
          committee.update_attributes!(
            :chamber => committee_node['house'].to_s,
            :name => committee_node['displayname'].to_s,
            :thomas_name => committee_node['thomasname'].to_s
          )
          committee_node.xpath('member').each do |member_node|
            committee.memberships.find_or_create_by_politician_id_and_role_and_congress_id(
              politician(member_node['id'].to_s).id,
              member_node['role'].to_s,
              @congress.id
            )
          end
          $stdout.print "C"
          $stdout.flush
          committee_node.xpath('subcommittee').each do |subcommittee_node|
            subcommittee = committee.children.find_by_code(subcommittee_node['code'].to_s) || Committee.new(:parent => committee, :code => subcommittee_node['code'].to_s)
            subcommittee.update_attributes!(
              :name => subcommittee_node['displayname'].to_s,
              :thomas_name => subcommittee_node['thomasname'].to_s
            )
            subcommittee_node.xpath('member').each do |member_node|
              subcommittee.memberships.find_or_create_by_politician_id_and_role_and_congress_id(
                politician(member_node['id'].to_s).id,
                member_node['role'].to_s,
                @congress.id
              )
            end
            subcommittee_node.xpath('subcommittee').each do |subsubcommittee_node|
              raise "Subsub #{subsubcommittee_node}"
            end
            $stdout.print "."
            $stdout.flush
          end
        end
        puts "\n\n"
      end
    end
  end
end