class ZipCode < ActiveRecord::Base
  has_many :congressional_district_zip_codes
  has_many :congressional_districts, through: :congressional_district_zip_codes
  has_many :locations

  class << self
    def sections_of(zip_code)
      zip_code.to_s.match(/^[^\d]*(\d{5})[-\s]*(\d{4})?\s*$/).try(:captures)
    end

    def zip_code(location)
      sections = sections_of(location).try(:map, &:presence).try(:compact)
      sections.join('-') if sections.present?
    end
  end

  def to_s
    zip_code.to_s
  end
end
