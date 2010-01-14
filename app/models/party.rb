class Party < ActiveRecord::Base
  BLACKLIST = ['no party'].freeze

  def to_s
    name
  end

  def abbrev
    name.first
  end
end
