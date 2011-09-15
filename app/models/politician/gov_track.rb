class Politician < ActiveRecord::Base
  module GovTrack
    def headshot
      @headshot ||= begin
        if gov_track_id.blank? && vote_smart_photo_url.blank?
          return nil
        end
        GovTrack::Headshot.new(gov_track_id, vote_smart_photo_url)
      end
    end

    # this implements much of the Paperclip::Attachment api for the sake of our reuse
    class Headshot
      ROOT_PATH = "http://www.govtrack.us/data/"
      TYPE_TO_WIDTH = {nil => nil, tiny: '25px', small: '50px', medium: '100px', large: '200px'}.freeze
      TYPE_TO_GOV_TRACK_WIDTH = {nil => nil, tiny: '50px', small: '50px', medium: '100px', large: '200px'}.freeze
      TYPE_TO_SIZE = {tiny: '25x30', small: '50x60', medium: '100x120', large: '200x240'}.freeze

      def initialize(gov_track_id, vote_smart_photo_url)
        raise ArgumentError unless gov_track_id.present? || vote_smart_photo_url.present?
        @gov_track_id = gov_track_id
        @vote_smart_photo_url = vote_smart_photo_url
      end

      def thumbnail
        self
      end

      def file?
        true
      end

      def styles
        Hash[TYPE_TO_GOV_TRACK_WIDTH.map do |(size, dimensions)|
          [size, {geometry: (dimensions || TYPE_TO_GOV_TRACK_WIDTH[:large])}]
        end]
      end

      def size(style = nil)
        TYPE_TO_SIZE.fetch(style)
      end

      def url(size = nil)
        if @gov_track_id
          size = TYPE_TO_GOV_TRACK_WIDTH.fetch(size)
          URI.join(ROOT_PATH, 'photos/', "#{[@gov_track_id, size].compact.join('-')}.jpeg").to_s
        else
          @vote_smart_photo_url if @vote_smart_photo_url.try(:ends_with?, '.jpg')
        end
      end
    end
  end
end
