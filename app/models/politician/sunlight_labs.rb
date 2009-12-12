class Politician < ActiveRecord::Base
  module SunlightLabs
    SUNLIGHT_ATTRIBUTES = %w[bioguide_id congress_office congresspedia_url crp_id district
      email event_id fax fec_id first_name gender gov_track_id in_office last_name middlename
      name_suffix nickname party phone senate_class state title twitter_id vote_smart_id webform
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
          self.send("#{attr}=", legislator.send(SUNLIGHT_RENAMES.fetch(attr, attr)))
        end
      else
        notify_exceptional(StandardError.new("SUNLIGHT: Unable to fetch data for '#{full_name}'"))
      end
    end
  end
end
