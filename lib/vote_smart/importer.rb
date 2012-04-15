module VoteSmart
  PVS_API_KEY = ENV['PVS_API_KEY'] unless defined?(PVS_API_KEY)
  VoteSmart.api_key = PVS_API_KEY

  module Importer
    class << self
      def fifty_states
        @fifty_states ||= VoteSmart::State.all.map(&:id)
      end
  
      def import_all
        ActiveRecord::Base.transaction do
          import_offices
          import_elections
          import_races
          Politician.update_current_candidacy_status!
        end
      end

      def import_elections
        ActiveRecord::Base.transaction do
          puts "Elections"
          fifty_states.each do |s|
            Rails.logger.info "Importing Elections for #{s} ..."
            if (e = valid_hash(VoteSmart::Election.get_election_by_year_state "2010", s))
              Rails.logger.info "Okay state #{s} has some elections for 2010..."
              elections = Array.wrap(e['elections']['election'])
              elections.each do |election_data|
                Rails.logger.info "Now processing #{election_data['name']}\n"
                state = UsState.find_by_abbreviation(election_data['stateId']) || raise("Missing state #{election_data['stateId']}")
                office_type = OfficeType.find_by_vote_smart_id(election_data['officeTypeId']) || raise("Office type #{election_data['officeTypeId']} not found")
                election = ::Election.find_by_vote_smart_id(election_data['electionId']) \
                 || ::Election.create!(
                  vote_smart_id: election_data['electionId'],
                  state_id: state.id,
                  office_type_id: office_type.id)
                election.update_attributes!(
                  name: election_data['name'],
                  state_id: state.id,
                  year: election_data['electionYear'],
                  special: object_to_boolean(election_data['special']),
                  office_type_id: office_type.id)
                Array.wrap(election_data['stage']).each do |es|
                  raise "#{election_data['stateId']} != #{es['stateId']}" if election_data['stateId'] != es['stateId']
                  election.stages.find_or_create_by_vote_smart_id_and_name_and_voted_on(es['stageId'], es['name'], es['electionDate'])
                  print '.'
                end
              end
            end
          end
        end
        puts
      end

      def import_candidate(candidate)
        bio = valid_hash(VoteSmart::CandidateBio.get_bio(candidate['candidateId']))
        bio_candidate = bio['bio']['candidate']
        politician = ::Politician.find_by_vote_smart_id(candidate['candidateId']) \
          || ::Politician.find_by_open_secrets_id(bio_candidate['crpId']) || begin
            case bio_candidate['crpId']
            when 'N00008957'
              Politician.find_by_bioguide_id('S000606')
            when 'N00027229'
              Politician.find_by_bioguide_id('F000451')
            when 'N00029461'
              # PVS falsely says he is Representative, United States House of Representatives, 2008-present
              # he lost this race by a small margin: http://en.wikipedia.org/wiki/Jay_Love
              ::Politician.create!(
                  vote_smart_id: candidate['candidateId'],
                  first_name: candidate['firstName'],
                  middle_name: candidate['middle_name'],
                  last_name: candidate['lastName'],
                  nickname: candidate['nickName'],
                  name_suffix: candidate['suffix'],
                  vote_smart_photo_url: bio_candidate['photo'],
                  open_secrets_id: bio_candidate['crp_id'],
                  gender: bio_candidate['gender'].first)
            end
          end || begin
            if bio['bio']['office'] && office = Array.wrap(bio['bio']['office']).detect {|o| o['type'] == 'Congressional' }
              politicians = Politician.find_all_by_first_name_and_last_name( bio_candidate['firstName'], bio_candidate['lastName'])
              politicians = Politician.find_all_by_last_name(bio_candidate['lastName']) if politicians.empty?
              if politicians.size > 1
                politicians =
                  if office['name'].first == 'U.S. House'
                    politicians.select {|politician| politician.representative_terms.any? {|term| term.state.abbreviation == bio_candidate['homeState'] } }
                  else
                    politicians.select {|politician| politician.senate_terms.any? {|term| term.state.abbreviation == bio_candidate['homeState'] } }
                  end
              end

              raise [politicians, bio].inspect if politicians.size > 1
              raise bio.inspect if politicians.empty?
              politicians.first
            end
          end || begin
            if bio_candidate['political'].to_s.split("\n").detect {|p| p.include?("Representative, United States House of Representatives") || p.include?('Senator, United States Senate') }
              politicians = Politician.find_all_by_first_name_and_last_name( bio_candidate['firstName'], bio_candidate['lastName'])
              politicians = Politician.find_all_by_last_name(bio_candidate['lastName']) if politicians.empty?
              if politicians.size > 1
                politicians =
                  if bio_candidate['political'].to_s.split("\n").detect {|p| p.include?("Representative, United States House of Representatives") }
                    politicians.select {|politician| politician.representative_terms.any? {|term| term.state.abbreviation == bio_candidate['homeState'] } }
                  else
                    politicians.select {|politician| politician.senate_terms.any? {|term| term.state.abbreviation == bio_candidate['homeState'] } }
                  end
              end

              raise [politicians, bio].inspect if politicians.size > 1
              raise bio.inspect if politicians.empty?
              politicians.first
              # raise bio_candidate['political'].to_s
            end
          end || ::Politician.create!(
              vote_smart_id: candidate['candidateId'],
              first_name: candidate['firstName'],
              middle_name: candidate['middle_name'],
              last_name: candidate['lastName'],
              nickname: candidate['nickName'],
              name_suffix: candidate['suffix'],
              vote_smart_photo_url: bio_candidate['photo'],
              open_secrets_id: bio_candidate['crp_id'],
              gender: bio_candidate['gender'].first)

        politician.update_attributes!(
          first_name: candidate['firstName'],
          middle_name: candidate['middle_name'],
          last_name: candidate['lastName'],
          nickname: candidate['nickName'],
          name_suffix: candidate['suffix'],
          vote_smart_photo_url: bio_candidate['photo'],
          open_secrets_id: bio_candidate['crp_id'],
          gender: bio_candidate['gender'].first
        )
        politician
      end

      def import_races
        puts "Races"
        ActiveRecord::Base.transaction do
          ::Election.all.each do |election|
            count = 0
            election.stages.each do |stage|
              candidate_hash = valid_hash(VoteSmart::Election.get_stage_candidates(election.vote_smart_id, stage.vote_smart_id))
              if candidate_hash
                Array.wrap(candidate_hash['stageCandidates']['candidate']).each do |candidate|
                  office = ::Office.find_by_vote_smart_id(candidate['officeId'])

                  race_params = {
                    office_id: office.id,
                    district_name: nil_if_blank(candidate['district']),
                  }
                  race = stage.races.first(conditions: race_params) || stage.races.create!(race_params)
                  politician = import_candidate(candidate)
                  if existing_candidacy = ::Candidacy.find_by_race_id_and_politician_id(race.id, politician.id)
                    unless existing_candidacy.status == candidate['status']
                      existing_candidacy.update_attributes(
                        party: candidate['party'],
                        status: candidate['status'],
                        vote_count: candidate['voteCount'],
                        vote_percent: candidate['votePercent']
                      )
                    end
                  else
                    ::Candidacy.create!(
                      race_id: race.id,
                      politician_id: politician.id,
                      party: candidate['party'],
                      status: candidate['status'],
                      vote_count: candidate['voteCount'],
                      vote_percent: candidate['votePercent']
                    )
                  end
                  print '.'
                end
              end
            end
            Rails.logger.info "Created #{count} races for #{election.name}\n"
          end
        end
        puts
      end
    
      def import_offices
        puts "Offices"
        valid_hash(VoteSmart::Office.get_types)['officeTypes']['type'].each do |type_data|
          office_type = ::OfficeType.find_by_level_id_and_branch_id_and_vote_smart_id_and_name(type_data['officeLevelId'], type_data['officeBranchId'], type_data['officeTypeId'], type_data['name']) \
            || ::OfficeType.create!(name: type_data['name'], level_id: type_data['officeLevelId'], branch_id: type_data['officeBranchId'], vote_smart_id: type_data['officeTypeId'])
          

          if office_data = valid_hash(VoteSmart::Office.get_offices_by_type(office_type.vote_smart_id))
            Array.wrap(office_data['offices']['office']).each do |office|
              office_type.offices.find_by_level_id_and_branch_id_and_vote_smart_id_and_name_and_title_and_short_title(office['officeLevelId'], office['officeBranchId'], office['officeId'], office['name'], office['title'], office['shortTitle']) \
              || office_type.offices.create!(name: office['name'], vote_smart_id: office['officeId'], title: office['title'], level_id: office['officeLevelId'], short_title: office['shortTitle'], branch_id: office['officeBranchId'])
              print '.'
            end
          end
        end
        puts
      end

      def import_interest_groups
        ActiveRecord::Base.transaction do
          puts "Categories"
          Array.wrap(VoteSmart::Rating.get_categories['categories']['category']).each do |category|
            subject = Subject.find_or_create_by_name(category['name'])
            subject.update_attribute(:vote_smart_id, category['categoryId'])
            print '.'
          end
          puts

          puts "Sig Subjects"
          max_cat_id = (Subject.first(order: 'vote_smart_id DESC', conditions: 'vote_smart_id is not null').vote_smart_id + 5).to_s
          sigs = ('0'..max_cat_id).flat_map do |cat_id|
            subject = Subject.find_by_vote_smart_id(cat_id)
            if sigs = valid_hash(VoteSmart::Rating.get_sig_list(cat_id))
              sigs = Array.wrap(sigs['sigs']['sig'])
              sigs.each do |sig|
                group = InterestGroup.find_by_vote_smart_id(sig['sigId']) \
                  || InterestGroup.create!(
                    name: sig['name'],
                    vote_smart_id: sig['sigId'])
                group.interest_group_subjects.create!(subject: subject) if subject && !group.subjects.include?(subject)
                print '.'
              end
              sigs
            end
          end.compact
          puts

          puts "Sigs"
          sigs.each do |sig|
            group = InterestGroup.find_by_vote_smart_id(sig['sigId']) || raise("No sig for #{sig.inspect}")
            if sig['parentId'] != '-1'
              parent = InterestGroup.find_by_vote_smart_id(sig['parentId'])
              raise "Parent #{sig['parentId']} not found" unless parent
              group.update_attributes(parent: parent)
            end
            group_data = VoteSmart::Rating.get_sig(sig['sigId'])['sig']
            group.update_attributes(
              name: group_data['name'],
              description: group_data['description'],
              address: nil_if_blank(group_data['address']),
              city: nil_if_blank(group_data['city']),
              state: nil_if_blank(group_data['state']),
              zip: nil_if_blank(group_data['zip']),
              phone1: nil_if_blank(group_data['phone1']),
              phone2: nil_if_blank(group_data['phone2']),
              fax: nil_if_blank(group_data['fax']),
              email: nil_if_blank(group_data['email']),
              website_url: nil_if_blank(group_data['url']),
              contact_name: nil_if_blank(group_data['contactName'])
            )
            print '.'
          end
          puts
        end
      end

      def import_ratings
        puts "Ratings"
        require 'typhoeus'
        VoteSmart::Rating.parallelize!
        politicians = Politician.vote_smart.select('id, vote_smart_id')
        InterestGroup.vote_smart.ratings_not_recently_updated.find_each do |group|
          ActiveRecord::Base.transaction do
            puts "InterestGroup: #{group.vote_smart_id} #{group.name}"
            politicians.each do |politician|
              VoteSmart::Rating.get_candidate_rating(politician.vote_smart_id, group.vote_smart_id) do |ratings|
                print 'P'
                if ratings.has_key?('error')
                  next if ratings['error']['errorMessage'] == 'No Ratings fit this criteria.'
                  raise ratings.inspect
                end
                Array.wrap(ratings['candidateRating']['rating']).each do |rating|
                  print '.'
                  report = group.reports.find_by_vote_smart_id(rating['ratingId']) || group.reports.create!(
                    vote_smart_id: rating['ratingId'],
                    timespan: rating['timespan'])
                  new_rating = report.ratings.find_by_politician_id(politician) \
                    || report.ratings.create(
                      politician: politician,
                      rating: rating['rating'],
                      description: rating['ratingText'])
                  if new_rating.rating != rating['rating']
                    if rating['rating'].present?
                      puts "Updating #{new_rating.rating} -> #{rating['rating']}, #{rating.inspect}"
                      new_rating.update_attributes!(
                        politician: politician,
                        rating: rating['rating'],
                        description: rating['ratingText'])
                    else
                      raise "Rating mismatch #{new_rating.rating} vs #{rating['rating']}, #{rating.inspect}"
                    end
                  end
                end
              end
            end
            VoteSmart::Rating.run
            group.touch(:ratings_updated_at)
          end
          puts
        end
        InterestGroupReport.calibrate_ratings
      end

      private
  
      def valid_hash(hash)
        hash unless hash['error']
      end

      def object_to_boolean(value)
         ["true", "1", "t"].include?(value.to_s.downcase)
      end
    
      def nil_if_blank(string)
        string if string.present?
      end
    end
  end
end
