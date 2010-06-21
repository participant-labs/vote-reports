class ZipCode < ActiveRecord::Base
  has_many :congressional_district_zip_codes
  has_many :congressional_districts, :through => :congressional_district_zip_codes
  has_many :locations
end
