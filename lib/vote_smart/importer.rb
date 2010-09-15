module VoteSmart
  class Importer
    class << self
      def import!
        new.import_ratings
      end
    end

    def initialize
      gem 'votesmart', '>= 0.3.0'
      PVS_API_KEY = ENV['PVS_API_KEY'] unless defined?(PVS_API_KEY)
      VoteSmart.api_key = PVS_API_KEY
      $stdout.sync = true
    end

    def import_ratings
      ActiveRecord::Base.transaction do
        sigs = to_array(VoteSmart::Rating.get_categories['categories']['category']).map do |category|
          subject = Subject.find_or_create_by_name(:name => category['name'])
          subject.update_attributes!(:vote_smart_id => category['categoryId'])
          sigs = to_array(VoteSmart::Rating.get_sig_list(category['categoryId'])['sigs']['sig'])
          sigs.each do |sig|
            group = InterestGroup.find_by_vote_smart_id(sig['sigId']) \
              || InterestGroup.create!(
                :name => sig['name'],
                :vote_smart_id => sig['sigId'])
            group.subjects << subject unless group.subjects.include?(subject)
          end
          sigs
        end.flatten.index_by {|sig| sig['sigId'] }.values.sort_by {|sig| sig['sigId'].to_i }

        sigs.each do |sig|
          puts "InterestGroup: #{sig['sigId']} #{sig['name']}"
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
            :address => group_data['address'],
            :city => group_data['city'],
            :state => group_data['state'],
            :zip => group_data['zip'],
            :phone1 => group_data['phone1'],
            :phone2 => group_data['phone2'],
            :fax => group_data['fax'],
            :email => group_data['email'],
            :url => group_data['url'],
            :contact_name => group_data['contactName']
          )

          Politician.paginated_each(:conditions => 'vote_smart_id IS NOT NULL') do |politician|
            $stdout.print 'P'
            ratings = VoteSmart::Rating.get_candidate_rating(politician.vote_smart_id, sig['sigId'])
            if ratings.has_key?('error')
              next if ratings['error']['errorMessage'] == 'No Ratings fit this criteria.'
              raise ratings.inspect
            end
            to_array(ratings['candidateRating']['rating']).each do |rating|
              $stdout.print '.'
              report = group.reports.find_by_vote_smart_id(rating['ratingId']) || group.reports.create!(
                :vote_smart_id => rating['ratingId'],
                :timespan => rating['timespan'])
              new_rating = report.ratings.find_by_politician_id(politician) \
                || report.ratings.create(
                  :politician => politician,
                  :rating => rating['rating'],
                  :description => rating['ratingText'])
              if new_rating.rating != rating['rating']
                raise "Rating mismatch: #{new_rating.rating} vs. #{rating['rating']}, #{rating.inspect}"
              end
            end
          end
          $stdout.print "\n"
        end
      end
    end

    private

    def to_array(obj)
      obj.is_a?(Array) ? obj : [obj]
    end
  end
end
