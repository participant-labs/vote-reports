class Politician
  module GovTrack
    HEADSHOT_TYPE_TO_SIZE = {:small => '50px', :medium => '100px', :large => '200px'}.freeze

    def headshot_url(type = nil)
      ::GovTrack::Politician.new(gov_track_id).headshot_url(HEADSHOT_TYPE_TO_SIZE[type])
    end
  end
end
