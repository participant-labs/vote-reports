class Politician < ActiveRecord::Base
  module GovTrack
    def headshot
      @headshot ||= begin
        if gov_track_id.blank?
          notify_hoptoad("Unable to fetch headshot, no gov_track_id for: #{inspect}")
          return nil
        end
        GovTrack::Headshot.new(gov_track_id)
      end
    end

    # this implements much of the Paperclip::Attachment api for the sake of our reuse
    class Headshot
      ROOT_PATH = "http://www.govtrack.us/data/"
      HEADSHOT_TYPE_TO_SIZE = {nil => nil, :small => '50px', :medium => '100px', :large => '200px'}.freeze

      def initialize(id)
        raise ArgumentError unless id.present?
        @id = id
      end

      def thumbnail
        self
      end

      def file?
        true
      end

      def styles
        HEADSHOT_TYPE_TO_SIZE.inject({}) do |all, (size, dimensions)|
          dimensions ||= HEADSHOT_TYPE_TO_SIZE[:large]
          all[size] = {:geometry => dimensions}
          all
        end
      end

      def url(size = nil)
        size = HEADSHOT_TYPE_TO_SIZE.fetch(size)
        URI.join(ROOT_PATH, 'photos/', "#{[@id, size].compact.join('-')}.jpeg").to_s
      end
    end
  end
end
