class District < ActiveRecord::Base
  belongs_to :state, :class_name => 'UsState', :foreign_key => :us_state_id
  has_many :zip_codes, :class_name => 'DistrictZipCode'

  has_many :representative_terms
  has_many :representatives, :through => :representative_terms, :source => :politician, :uniq => true do
    def in_office
      scoped(
      :conditions => [
        '((representative_terms.started_on, representative_terms.ended_on) OVERLAPS (DATE(:yesterday), DATE(:tomorrow)))',
        {:yesterday => Date.yesterday, :tomorrow => Date.tomorrow}
      ])
    end
  end

  delegate :senators, :to => :state

  named_scope :with_zip, lambda {|zip_code|
    zip_code, plus_4 = zip_code.to_s.match(/(?:^|[^\d])(\d\d\d\d\d)[-\s]*(\d{0,4})\s*$/).try(:captures)
    if zip_code.blank?
      {:conditions => '0 = 1'}
    elsif plus_4.blank?
      {:joins => :zip_codes, :conditions => {:'district_zip_codes.zip_code' => zip_code}}
    elsif DistrictZipCode.exists?(:zip_code => zip_code, :plus_4 => plus_4)
      {:joins => :zip_codes, :conditions => {
        :'district_zip_codes.zip_code' => zip_code, :'district_zip_codes.plus_4' => plus_4
      }}
    else
      {:joins => :zip_codes, :conditions => [
        "district_zip_codes.zip_code = ? AND (district_zip_codes.plus_4 = ? OR district_zip_codes.plus_4 IS NULL)", zip_code, plus_4
      ]}
    end
  }

  class << self
    def find_by_name(name)
      state, district = name.split('-')
      district = 0 if district == 'At_large'
      first(:conditions => {'districts.district' => district, 'us_states.abbreviation' => state}, :joins => :state)
    end
  end

  def politicians
    Politician.from_district(self)
  end

  def abbreviation
    district_abbrv = self.district == 0 ? 'At large' : self.district.to_s
    "#{state.abbreviation}-#{district_abbrv}"
  end

  def to_param
    abbreviation.gsub(' ', '_')
  end

  def full_name
    district = self.district == 0 ? 'at-large' : self.district.ordinalize if self.district
    district = "the #{district} congressional district of " if district
    "#{district}#{state.full_name}"
  end

  def full_title_name
    district = self.district == 0 ? 'At-large' : self.district.ordinalize if self.district
    district = "The #{district} Congressional District of " if district
    "#{district}#{state.full_name}"
  end
end
