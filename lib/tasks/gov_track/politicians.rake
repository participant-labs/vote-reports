namespace :gov_track do
  namespace :politicians do
    def party(name)
      return nil if name.blank? || Party::BLACKLIST.include?(name)
      @parties ||= Party.all.index_by(&:name)
      @parties.fetch(name) do
        @parties[name] = Party.create(:name => name)
      end
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
              attrs[method] = role[attr].to_s if role[attr].present?
              attrs
            end
            attrs['party'] = party(attrs.delete('party'))
            attrs.symbolize_keys!

            case role['type']
            when 'rep'
              state = UsState.find_by_abbreviation(role['state']) || raise("Unknown state #{role['state']}")
              district = role['district'].to_i
              district = 0 if district == -1
              district = District.first(:conditions => {:us_state_id => state, :district => district}) \
                || District.create(:state => state, :district => district)
              attrs.merge!(:district => district)
              politician.representative_terms.find_by_started_on(role['startdate'].to_date).tap do |term|
                term && term.update_attributes(attrs)
              end || politician.representative_terms.create(attrs)
            when 'sen'
              state = UsState.find_by_abbreviation(role['state']) || raise("Unknown state #{role['state']}")
              attrs.merge!(:senate_class => role['class'], :state => state)
              politician.senate_terms.find_by_started_on(role['startdate'].to_date).tap do |term|
                term && term.update_attributes(attrs)
              end || politician.senate_terms.create(attrs)
            when 'prez'
              politician.presidential_terms.find_by_started_on(role['startdate'].to_date).tap do |term|
                term && term.update_attributes(attrs)
              end || politician.presidential_terms.create(attrs)
            else
              raise role.inspect
            end.tap do |term|
              $stdout.print "P" if term.party.nil?
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