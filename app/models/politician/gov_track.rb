class Politician < ActiveRecord::Base
  module GovTrack
    HEADSHOT_TYPE_TO_SIZE = {:small => '50px', :medium => '100px', :large => '200px'}.freeze

    def headshot_url(type = nil)
      if gov_track_id.blank?
        notify_exceptional("Unable to fetch headshot, no gov_track_id for: #{inspect}")
        return nil
      end
      ::GovTrack::Politician.new(gov_track_id).headshot_url(HEADSHOT_TYPE_TO_SIZE[type])
    end
  end
end
