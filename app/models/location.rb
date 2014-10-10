class Location < ActiveRecord::Base
  belongs_to :zip_code

  scope :random, -> { order('random()') }

  def to_s
    "#{city.titleize}, #{state}"
  end
end
