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
          import_elections
          import_offices
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
              elections = array_of_hashes(e['elections']['election'])
              elections.each do |election_data|
                Rails.logger.info "Now processing #{election_data['name']}\n"
                election = ::Election.create!(:name => election_data['name'],
                                 :vote_smart_id => election_data['electionId'],
                                 :state_id => UsState.find_by_abbreviation(election_data['stateId']),
                                 :year => election_data['electionYear'],
                                 :special => object_to_boolean(election_data['special']),
                                 :office_type => election_data['officeTypeId'])
                array_of_hashes(election_data['stage']).each do |es|
                  raise "#{election_data['stateId']} != #{es['stateId']}" if election_data['stateId'] != es['stateId']
                  election.stages.create!(
                    :vote_smart_id => es['stageId'],
                    :name => es['name'],
                    :voted_on => es['electionDate']
                  )
                  print '.'
                end
              end
            end
          end
        end
        puts
      end

      def import_election_dates
        fifty_states.each do |state|
          Rails.logger.info "Importing Elections for #{s} ..."
          if (e = valid_hash(VoteSmart::Election.get_election_by_year_state "2010", state))
            Rails.logger.info "Okay state #{s} has some elections for 2010..."
            elections = array_of_hashes(e['elections']['election'])
            elections.each do |election|
              Rails.logger.info "Now processing #{election}"
              election_stages(election).each do |es|
                Rails.logger.info "#{es['name']}\n"
                ::Election.first(:conditions => {:vote_smart_id => es['electionId'], :stage => es['stageName']}).update_attribute(:date, es['electionDate'])
              end
            end
          end
        end
      end

      def import_candidate(candidate)
        bio = valid_hash(VoteSmart::CandidateBio.get_bio(candidate['candidateId']))
        bio_candidate = bio['bio']['candidate']
        politician = ::Politician.find_by_vote_smart_id(candidate['candidateId']) \
          || ::Politician.find_by_crp_id(bio_candidate['crpId']) || begin
            if office = to_array(bio['bio']['office']).detect {|o| o['type'] == 'Congressional' }
              politicians = Politician.find_all_by_first_name_and_last_name( bio_candidate['firstName'], bio['bio']['candidate']['lastName'])
              raise office.inspect
            elsif bio_candidate['political'].to_s.split("\n").detect {|p| p.include?("Representative, United States House of Representatives") || p.include?('Senator, United States Senate') }
              raise bio_candidate['political'].to_s
            else
              ::Politician.create!(:vote_smart_id => candidate['candidateId'])
            end
          end
        politician.update_attributes!(
          :first_name => candidate['firstName'],
          :middle_name => candidate['middle_name'],
          :last_name => candidate['lastName'],
          :nickname => candidate['nickName'],
          :name_suffix => candidate['suffix'],
          :vote_smart_photo_url => bio_candidate['photo'],
          :crp_id => bio_candidate['crp_id'],
          :gender => bio_candidate['gender'].first
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
                array_of_hashes(candidate_hash['stageCandidates']['candidate']).each do |candidate|
                  office = ::Office.find_by_vote_smart_id(candidate['officeId'])

                  race_params = {
                    :office_id => office.id,
                    :district => nil_if_blank(candidate['district']),
                  }
                  race = stage.races.first(:conditions => race_params) || stage.races.create!(race_params)
                  politician = import_candidate(candidate)
                  ::Candidacy.find_or_create_by_race_id_and_politician_id(
                    :race_id => race.id,
                    :politician_id => politician.id,
                    :party => candidate['party'],
                    :status => candidate['status'],
                    :vote_count => candidate['voteCount'],
                    :vote_percent => candidate['votePercent']
                  )
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
          office_type = ::OfficeType.create!(:name => type_data['name'], :level_id => type_data['officeLevelId'], :branch_id => type_data['officeBranchId'], :vote_smart_id => type_data['officeTypeId'])

          if office_data = valid_hash(VoteSmart::Office.get_offices_by_type(office_type.vote_smart_id))
            array_of_hashes(office_data['offices']['office']).each do |office|
              office_type.offices.create!(:name => office['name'], :vote_smart_id => office['officeId'], :title => office['title'], :level_id => office['officeLevelId'], :short_title => office['shortTitle'], :branch_id => office['officeBranchId'])
              print '.'
            end
          end
        end
        puts
      end

      def import_measures
        dates = elections = []
        pp = []
        Constants::STATE_NAMES.each_key do |state|
          puts "Getting measures for state #{s} ...\n"
          vs = VoteSmart::Measure.get_measures_by_year_state "2010", state
          puts vs
          if valid_hash(vs)
            array_of_hashes(vs['measures']['measure']).each do |m|
              puts m
              p = (VoteSmart::Measure.get_measure m['measureId'])['measure']
              unless dates.include?(p['electionDate'])
                dates << m['electionDate']
                elections << e = ::Election.create!({:date => p['electionDate'].to_date,
                                     :state_id => state,
                                     :name => "#{p['electionDate']} #{Constants::STATE_NAMES[s]} Propositions"})
              else
                e = elections.detect { |a| a.date == m['electionDate'].to_date }
              end
              pp << ::Proposition.create!({
                 :name => "#{p['measureCode']}: #{p['title']}",
                 :description => p['summary'],
                 :ballot_text => p['measureText'],
                 :proposition_title => p['title'],
                 :proposition_symbol => p['measureCode'],
                 :state_id => state,
                 :election_id => e.id,
                 :outcome => p['outcome'],
                 :summary_url => p['summaryUrl'],
                 :no => p['no'],
                 :con_url => p['conUrl'],
                 :pro_url => p['proUrl'],
                 :yes => p['yes'],
                 :url => p['url'],
                 :vote_smart_id => p['measureId'],
                 :text_url => p['textUrl']
               })
            end
          end
        end   
      end

      def import_interest_groups
        ActiveRecord::Base.transaction do
          puts "Categories"
          to_array(VoteSmart::Rating.get_categories['categories']['category']).each do |category|
            subject = Subject.find_or_create_by_name(:name => category['name'])
            subject.update_attribute(:vote_smart_id, category['categoryId'])
            print '.'
          end
          puts

          puts "Sig Subjects"
          max_cat_id = (Subject.first(:order => 'vote_smart_id DESC', :conditions => 'vote_smart_id is not null').vote_smart_id + 5).to_s
          sigs = ('0'..max_cat_id).map do |cat_id|
            subject = Subject.find_by_vote_smart_id(cat_id)
            if sigs = valid_hash(VoteSmart::Rating.get_sig_list(cat_id))
              sigs = to_array(sigs['sigs']['sig'])
              sigs.each do |sig|
                group = InterestGroup.find_by_vote_smart_id(sig['sigId']) \
                  || InterestGroup.create!(
                    :name => sig['name'],
                    :vote_smart_id => sig['sigId'])
                group.interest_group_subjects.create!(:subject => subject) if subject && !group.subjects.include?(subject)
                print '.'
              end
              sigs
            end
          end.compact.flatten
          puts

          puts "Sigs"
          sigs.each do |sig|
            group = InterestGroup.find_by_vote_smart_id(sig['sigId']) || raise("No sig for #{sig.inspect}")
            if sig['parentId'] != '-1'
              parent = InterestGroup.find_by_vote_smart_id(sig['parentId'])
              raise "Parent #{sig['parentId']} not found" unless parent
              group.update_attributes(:parent => parent)
            end
            group_data = VoteSmart::Rating.get_sig(sig['sigId'])['sig']
            group.update_attributes(
              :name => group_data['name'],
              :description => group_data['description'],
              :address => nil_if_blank(group_data['address']),
              :city => nil_if_blank(group_data['city']),
              :state => nil_if_blank(group_data['state']),
              :zip => nil_if_blank(group_data['zip']),
              :phone1 => nil_if_blank(group_data['phone1']),
              :phone2 => nil_if_blank(group_data['phone2']),
              :fax => nil_if_blank(group_data['fax']),
              :email => nil_if_blank(group_data['email']),
              :url => nil_if_blank(group_data['url']),
              :contact_name => nil_if_blank(group_data['contactName'])
            )
            print '.'
          end
          puts
        end
      end

      def import_ratings
        puts "Ratings"
        VoteSmart::Rating.parallelize!
        InterestGroup.vote_smart.ratings_not_recently_updated.each do |group|
          ActiveRecord::Base.transaction do
            puts "InterestGroup: #{group.vote_smart_id} #{group.name}"
            Politician.each_page(:conditions => 'vote_smart_id IS NOT NULL') do |politicians|
              politicians.each do |politician|
                VoteSmart::Rating.get_candidate_rating(politician.vote_smart_id, group.vote_smart_id) do |ratings|
                  print 'P'
                  if ratings.has_key?('error')
                    next if ratings['error']['errorMessage'] == 'No Ratings fit this criteria.'
                    raise ratings.inspect
                  end
                  to_array(ratings['candidateRating']['rating']).each do |rating|
                    print '.'
                    report = group.reports.find_by_vote_smart_id(rating['ratingId']) || group.reports.create!(
                      :vote_smart_id => rating['ratingId'],
                      :timespan => rating['timespan'])
                    new_rating = report.ratings.find_by_politician_id(politician) \
                      || report.ratings.create(
                        :politician => politician,
                        :rating => rating['rating'],
                        :description => rating['ratingText'])
                    if new_rating.rating != rating['rating']
                      if rating['rating'].present?
                        puts "Updating #{new_rating.rating} -> #{rating['rating']}, #{rating.inspect}"
                        new_rating.update_attributes!(
                          :politician => politician,
                          :rating => rating['rating'],
                          :description => rating['ratingText'])
                      else
                        raise "Rating mismatch #{new_rating.rating} vs #{rating['rating']}, #{rating.inspect}"
                      end
                    end
                  end
                end
              end
              VoteSmart::Rating.run
            end
            group.touch(:ratings_updated_at)
          end
          puts
        end
        InterestGroupReport.calibrate_ratings
      end

      private

      def to_array(obj)
        obj.is_a?(Array) ? obj : [obj]
      end

      def array_of_hashes(array_or_hash)
        return array_or_hash if array_or_hash.is_a? Array
        return [array_or_hash] if array_or_hash.is_a? Hash
        raise "VoteSmart::Importer Unexpected Data Type Error: I didn't think I'd get #{array_or_hash}!!!\n"
      end
  
      def valid_hash(hash)
        return nil if hash['error']
        hash
      end

      def object_to_boolean(value)
         return [true, "true", 1, "1", "T", "t"].include?(value.class == String ? value.downcase : value)
      end
    
      def nil_if_blank(string)
        (string && string.blank?) ? nil : string
      end
    end
  end
end
