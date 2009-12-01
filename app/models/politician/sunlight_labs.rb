class Politician
  module SunlightLabs
    SUNLIGHT_ATTRIBUTES = %w[bioguide_id congress_office congresspedia_url crp_id district email event_id fax fec_id first_name gender gov_track_id in_office last_name middlename name_suffix nickname party phone senate_class state title twitter_id vote_smart_id webform website youtube_url].freeze

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
      legislators = Sunlight::Legislator.all(:votesmart_id => vote_smart_id)
      if legislators.empty?
        Rails.logger.error "SUNLIGHT: Unable to fetch data for '#{full_name}'"
      else
        legislator = legislators.first
        Rails.logger.info "SUNLIGHT: Fetched '#{full_name}' as '#{legislator.firstname} #{legislator.lastname}'"
        SUNLIGHT_ATTRIBUTES.each do |attr|
          self.send("#{attr}=", legislator.send(SUNLIGHT_RENAMES.fetch(attr, attr)))
        end
      end
    end
  end
end
