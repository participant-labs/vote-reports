class CongressionalDistrictZipCode < ActiveRecord::Base
  belongs_to :congressional_district
  has_one :state, through: :congressional_district
  belongs_to :zip_code
end
