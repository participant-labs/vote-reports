class District::Level
  LEVELS = {
    'federal' => {
      :fill_color => 'red',
      :stroke_color => 'gray',
      :description => 'Congressional District'
    },
    'state_upper' => {
      :fill_color => 'green',
      :stroke_color => 'gray',
      :description => 'Upper House District'
    },
    'state_lower' => {
      :fill_color => 'blue',
      :stroke_color => 'gray',
      :description => 'Lower House District'
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
  delegate :to_sym, :to => :level
end
