class District < ActiveRecord::Base
  belongs_to :state, :class_name => 'UsState', :foreign_key => :us_state_id
  has_many :zip_codes, :class_name => 'DistrictZipCode'

  named_scope :with_zip, lambda {|zip_code|
    zip_code, plus_4 = zip_code.strip.split(/[-\s]+/)
    if plus_4
      {:joins => :zip_codes, :conditions => {:'district_zip_codes.zip_code' => zip_code, :'district_zip_codes.plus_4' => plus_4}}
    else
      {:joins => :zip_codes, :conditions => {:'district_zip_codes.zip_code' => zip_code}}
    end
  }

  def politicians
    Politician.scoped(:conditions => [
      "politician_terms.us_state_id = ? AND (politician_terms.type = 'SenateTerm' OR (politician_terms.type = 'RepresentativeTerm' AND politician_terms.district = ?))", us_state_id, district
    ], :joins => :politician_terms)
  end
end
