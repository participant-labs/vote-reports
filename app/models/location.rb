class Location < ActiveRecord::Base
  belongs_to :zip_code

  def to_s
    "#{city.titleize}, #{state}"
  end
end
