class BillType
  TYPES = {
    'h' => {:long => 'House Bill', :short => 'H.R.'},
    'hr' => {:long => 'House Resolution', :short => 'H.Res.'},
    'hj' => {:long => 'House Joint Resolution', :short => 'H.J.Res.'},
    'hc' => {:long => 'House Concurrent Resolution', :short => 'H.Con.Res.'},

    's' => {:long => 'Senate Bill', :short => 'S.'},
    'sr' => {:long => 'Senate Resolution', :short => 'S.Res.'},
    'sj' => {:long => 'Senate Joint Resolution', :short => 'S.J.Res.'},
    'sc' => {:long => 'Senate Concurrent Resolution', :short => 'S.Con.Res.'}
  }.freeze

  attr_reader :abbrev

  def initialize(abbrev)
    raise "Invalid bill type #{abbrev}" unless TYPES.has_key?(abbrev)
    @abbrev = abbrev
  end

  def long_name
    TYPES.fetch(@abbrev).fetch(:long)
  end

  def short_name
    TYPES.fetch(@abbrev).fetch(:short)
  end
  alias_method :to_s, :short_name
end