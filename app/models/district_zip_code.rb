class DistrictZipCode < ActiveRecord::Base
  belongs_to :district
  has_one :state, :through => :district
  belongs_to :zip_code
end
