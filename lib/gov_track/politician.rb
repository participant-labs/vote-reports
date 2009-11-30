module GovTrack
  ROOT_PATH = "http://www.govtrack.us/data/"

  class Politician
    HEADSHOT_SIZES = [nil, '50px', '100px', '200px'].freeze

    def initialize(id)
      raise ArgumentError unless id.present?
      @id = id
    end

    def headshot_url(size = nil)
      raise ArgumentError, 'unknown photo size' unless HEADSHOT_SIZES.include?(size)
      URI.join(ROOT_PATH, 'photos/', "#{[@id, size].compact.join('-')}.jpeg").to_s
    end
  end
end