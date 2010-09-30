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
      TYPE_TO_WIDTH = {nil => nil, :tiny => '50px', :small => '50px', :medium => '100px', :large => '200px'}.freeze
      TYPE_TO_SIZE = {:tiny => '25x30', :small => '50x60', :medium => '100x120', :large => '200x240'}.freeze

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
        Hash[TYPE_TO_WIDTH.map do |(size, dimensions)|
          [size, {:geometry => (dimensions || TYPE_TO_WIDTH[:large])}]
        end]
      end

      def size(style = nil)
        TYPE_TO_SIZE.fetch(style)
      end

      def url(size = nil)
        size = TYPE_TO_WIDTH.fetch(size)
        URI.join(ROOT_PATH, 'photos/', "#{[@id, size].compact.join('-')}.jpeg").to_s
      end
    end
  end
end
