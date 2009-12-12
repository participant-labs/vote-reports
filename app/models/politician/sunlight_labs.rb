class Politician < ActiveRecord::Base
  module SunlightLabs
    SUNLIGHT_ATTRIBUTES = %w[bioguide_id congress_office congresspedia_url crp_id district
      email eventful_id fax fec_id first_name gender gov_track_id in_office last_name middlename
      name_suffix nickname party phone state title twitter_id vote_smart_id webform
      website youtube_url
    ].freeze

    SUNLIGHT_RENAMES = {
      'first_name' => 'firstname',
      'last_name' => 'lastname',
      'gov_track_id' => 'govtrack_id',
      'vote_smart_id' => 'votesmart_id'
    }.freeze

    def self.included(base)
      base.after_validation_on_create :load_sunlight_labs_data
    end

    def load_sunlight_labs_data
      find_by = {:votesmart_id => vote_smart_id} if vote_smart_id.present?
      find_by = {:govtrack_id => gov_track_id} if gov_track_id.present?

      if legislator = Sunlight::Legislator.find(find_by.merge(:all_legislators => true))
        Rails.logger.info "SUNLIGHT: Fetched '#{full_name}' as '#{legislator.firstname} #{legislator.lastname}'"
        SUNLIGHT_ATTRIBUTES.each do |attr|
          value = legislator.send(SUNLIGHT_RENAMES.fetch(attr, attr))
          self.send("#{attr}=", value) if value.present?
        end
        protect_sunlight_attr(:eventful_id, 'P0-001-000016084-2', :for => {:vote_smart_id => '27067'})
        protect_sunlight_attr(:twitter_id, 'RepMikeRogersAL', :for => {:vote_smart_id => '5705'})
      else
        notify_exceptional(StandardError.new("SUNLIGHT: Unable to fetch data for '#{full_name}'"))
      end
    rescue Sunlight::MultipleLegislatorsReturnedError => e
      notify_exceptional(Sunlight::MultipleLegislatorsReturnedError.new([e.message,"for #{inspect}"].join(' ')))
    end

    def protect_sunlight_attr(attr, value, options)
      condition = options[:for]
      if send(attr) == value
        if send(condition.keys.first) != condition[condition.keys.first]
          self.send("#{attr}=", nil)
        else
          #Update others to make this name available
          Politician.update_all({attr => nil}, {attr => value})
        end
      end
    end
  end
end
