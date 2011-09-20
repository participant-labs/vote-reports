class District::Level
  LEVELS = {
    'federal' => {
      fill_color: '#f00',
      text_color: '#d00',
      stroke_color: '#8b0000',
      description: 'Congressional District',
      sort_order: 1
    },
    'state_upper' => {
      fill_color: '#0f0',
      text_color: '#0c0',
      stroke_color: '#006400',
      description: 'Upper House District',
      sort_order: 2
    },
    'state_lower' => {
      fill_color: '#00f',
      text_color: '#00d',
      stroke_color: '#00008b',
      description: 'Lower House District',
      sort_order: 3
    }
  }

  class << self
    def levels
      LEVELS.keys
    end
  end

  def initialize(level)
    @level = level
  end

  def method_missing(method, *args)
    @attrs ||= LEVELS.fetch(level)
    @attrs.fetch(method.to_sym)
  end

  attr_reader :level
  alias_method :to_s, :level
  delegate :to_sym, to: :level
end
