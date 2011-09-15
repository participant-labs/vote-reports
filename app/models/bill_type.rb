class BillType < String
  TYPES = {
    'h' => {long: 'House Bill', short: 'H.R.'},
    'hr' => {long: 'House Resolution', short: 'H.Res.'},
    'hj' => {long: 'House Joint Resolution', short: 'H.J.Res.'},
    'hc' => {long: 'House Concurrent Resolution', short: 'H.Con.Res.'},

    's' => {long: 'Senate Bill', short: 'S.'},
    'sr' => {long: 'Senate Resolution', short: 'S.Res.'},
    'sj' => {long: 'Senate Joint Resolution', short: 'S.J.Res.'},
    'sc' => {long: 'Senate Concurrent Resolution', short: 'S.Con.Res.'}
  }.freeze

  class << self
    def valid_types
      @valid_types ||= TYPES.keys
    end
  end

  def long_name
    TYPES.fetch(self).fetch(:long)
  end

  def short_name
    TYPES.fetch(self).fetch(:short)
  end
  alias to_s short_name
end