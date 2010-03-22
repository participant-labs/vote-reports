namespace :vote_smart do
  task :import => :environment do
    def to_array(obj)
      obj.is_a?(Array) ? obj : [obj]
    end

    require 'vote_smart'
    VoteSmart.api_key = ENV['PVS_API_KEY']
    $stdout.sync = true

    ActiveRecord::Base.transaction do
      to_array(VoteSmart::Rating.get_categories['categories']['category']).each do |category|
        puts "Subject: #{category['name']}"
        subject = Subject.find_or_create_by_name(
          :name => category['name'])
        subject.update_attributes(:vote_smart_id => category['categoryId'])

        sigs = to_array(VoteSmart::Rating.get_sig_list(category['categoryId'])['sigs']['sig'])
        sigs.each do |sig|
          InterestGroup.find_or_create_by_vote_smart_id(
            :subject => subject,
            :name => sig['name'],
            :vote_smart_id => sig['sigId'])
        end
        sigs.each do |sig|
          puts "  * InterestGroup: #{sig['name']}"
          group = InterestGroup.find_by_vote_smart_id(sig['sigId'])
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
              politician.interest_group_ratings.find_or_create_by_vote_smart_id(
                :interest_group => group,
                :vote_smart_id => rating['ratingId'],
                :rating => rating['rating'],
                :description => rating['ratingText'],
                :time_span => rating['timespan']
              )
            end
          end
          $stdout.print "\n"
        end
      end
    end
  end
end