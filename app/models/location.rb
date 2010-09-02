class Location < ActiveRecord::Base
  belongs_to :zip_code

  named_scope :random, :order => 'random()'

  def to_s
    "#{city.titleize}, #{state}"
  end
end
