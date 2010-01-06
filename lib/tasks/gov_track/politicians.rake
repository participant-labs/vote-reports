namespace :gov_track do
  namespace :politicians do
    def party_id(name)
      return nil if name.blank? || Party::BLACKLIST.include?(name)
      @parties ||= Party.all.index_by(&:name)
      @parties.fetch(name) do
        @parties[name] = Party.create(:name => name)
      end.id
    end

    desc "Process Politicians"
    task :unpack => :'gov_track:support' do
      data_path = ENV['MEETING'] ? "us/#{ENV['MEETING']}/people.xml" : "us/people.xml"
      doc = Nokogiri::XML(open(gov_track_path(data_path)))

      ActiveRecord::Base.transaction do
        doc.xpath('people/person').each do |person|
          politician = Politician.find_or_create_by_gov_track_id(person['id'])
          politician.update_attributes({
              'lastname' => 'last_name',
              'middlename' => 'middle_name',
              'firstname' => 'first_name',
              'bioguideid' => 'bioguide_id',
              'metavidid' => 'metavid_id',
              'osid' => 'open_secrets_id',
              'birthday' => 'birthday',
              'gender' => 'gender',
              'religion' => 'religion'
            }.inject({}) do |attrs, (attr, method)|
              attrs[method] = person[attr] if person[attr].present?
              attrs
          end)

          person.xpath('role').each do |role|
            attrs = {
              'startdate' => 'started_on',
              'enddate' => 'ended_on',
              'url' => 'url',
              'party' => 'party'
            }.inject({}) do |attrs, (attr, method)|
              attrs[method] = role[attr] if role[attr].present?
              attrs
            end
            attrs['party_id'] = party_id(attrs.delete('party'))

            case role['type']
            when 'rep'
              politician.representative_terms.find_or_create_by_started_on(role['startdate'].to_date) \
                .update_attributes(attrs.merge(:district => role['district'], :state => role['state']))
            when 'sen'
              politician.senate_terms.find_or_create_by_started_on(role['startdate'].to_date) \
                .update_attributes(attrs.merge(:senate_class => role['class'], :state => role['state']))
            when 'prez'
              politician.presidential_terms.find_or_create_by_started_on(role['startdate'].to_date) \
                .update_attributes(attrs)
            else
              raise role.inspect
            end
          end

          $stdout.print "."
          $stdout.flush
        end
        puts
      end
    end
  end
end