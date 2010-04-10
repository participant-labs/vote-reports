class ZipCode < ActiveRecord::Base
  has_many :district_zip_codes
  has_many :districts, :through => :district_zip_codes
  has_many :locations
end
