class CongressionalDistrict < ActiveRecord::Base
  belongs_to :state, class_name: 'UsState', foreign_key: :us_state_id
  has_many :congressional_district_zip_codes
  has_many :zip_codes, through: :congressional_district_zip_codes
  belongs_to :district
  delegate :level, to: :district

  has_many :representative_terms
  has_many :representatives, -> { uniq }, through: :representative_terms, source: :politician do
    def in_office
      where(['politicians.current_office_type = ? AND politicians.current_office_id IN(?)', 'RepresentativeTerm', proxy_owner.representative_terms])
    end
  end

  delegate :senators, :presidents, to: :state

  scope :with_zip, ->(zip_code) {
    zip_code, plus_4 = ZipCode.sections_of(zip_code)
    if zip_code.blank?
      none
    elsif plus_4.blank?
      joins(:zip_codes).where(:'zip_codes.zip_code' => zip_code)
    elsif CongressionalDistrictZipCode.joins(:zip_code).where(
        :'zip_codes.zip_code' => zip_code, :'congressional_district_zip_codes.plus_4' => plus_4
      ).exists?
      joins(:zip_codes).where(
        :'zip_codes.zip_code' => zip_code, :'congressional_district_zip_codes.plus_4' => plus_4
      )
    else
      joins(:zip_codes).where([
        "zip_codes.zip_code = ? AND (congressional_district_zip_codes.plus_4 = ? OR congressional_district_zip_codes.plus_4 IS NULL)", zip_code, plus_4
      ])
    end
  }

  scope :for_city, ->(address) {
    city, state = address.upcase.split(', ', 2)
    if city.blank?
      none
    elsif state.blank?
      select('DISTINCT congressional_districts.*').joins(zip_codes: :locations)
        .where('locations.city = ?', city)
    else
      select('DISTINCT congressional_districts.*').joins(:state, zip_codes: :locations).where(
        'locations.city = ? AND locations.state = ? AND us_states.abbreviation = ?',
        city, state, state
      )
    end
  }

  class << self
    def find_by_name(name)
      state, district = name.split('-')
      district = 0 if district == 'At_large'
      joins(:state).where(
        'congressional_districts.district_number' => district,
        'us_states.abbreviation' => state
      ).first
    end
  end

  def politicians
    Politician.from_congressional_district(self).with_in_office_terms
  end

  def title
    "#{which} Congressional District of #{state.full_name}"
  end
  alias_method :full_name, :title

  def district_geometries
    @district_geometry ||= District.federal.where(
      us_state_id: us_state_id, name: district_abbreviation)
  end

  def district_abbreviation
    (at_large? || unidentified?) ? 'At large' : district_number.to_s
  end

  def abbreviation
    "#{state.abbreviation}-#{district_abbreviation}"
  end

  def to_param
    abbreviation.tr(' ', '_')
  end

  def unidentified?
    district_number == nil
  end

  def at_large?
    district_number == 0
  end

  def which
    if unidentified?
      'Unidentified'
    elsif at_large?
      'At-large'
    else
      district_number.ordinalize
    end
  end
end
