class CongressionalDistrict < ActiveRecord::Base
  belongs_to :state, :class_name => 'UsState', :foreign_key => :us_state_id
  has_many :congressional_district_zip_codes
  has_many :zip_codes, :through => :congressional_district_zip_codes
  belongs_to :district

  has_many :representative_terms
  has_many :representatives, :through => :representative_terms, :source => :politician, :uniq => true do
    def in_office
      scoped(:conditions => ['politicians.current_office_type = ? AND politicians.current_office_id IN(?)', 'RepresentativeTerm', proxy_owner.representative_terms])
    end
  end

  delegate :senators, :presidents, :to => :state

  named_scope :with_zip, lambda {|zip_code|
    zip_code, plus_4 = ZipCode.sections_of(zip_code)
    if zip_code.blank?
      {:conditions => '0 = 1'}
    elsif plus_4.blank?
      {:joins => :zip_codes, :conditions => {:'zip_codes.zip_code' => zip_code}}
    elsif CongressionalDistrictZipCode.scoped(:joins => :zip_code, :conditions => {
        :'zip_codes.zip_code' => zip_code, :'congressional_district_zip_codes.plus_4' => plus_4
      }).exists?
      {:joins => :zip_codes, :conditions => {
        :'zip_codes.zip_code' => zip_code, :'congressional_district_zip_codes.plus_4' => plus_4
      }}
    else
      {:joins => :zip_codes, :conditions => [
        "zip_codes.zip_code = ? AND (congressional_district_zip_codes.plus_4 = ? OR congressional_district_zip_codes.plus_4 IS NULL)", zip_code, plus_4
      ]}
    end
  }

  named_scope :for_city, lambda {|address|
    city, state = address.upcase.split(', ', 2)
    if city.blank?
      {:conditions => '0 = 1'}
    elsif state.blank?
      {:select => 'DISTINCT congressional_districts.*',
      :joins => {:zip_codes => :locations},
      :conditions => {:'locations.city' => city}}
    else
      {:select => 'DISTINCT congressional_districts.*',
      :joins => [{:zip_codes => :locations}, :state],
      :conditions => {
        :'locations.city' => city, :'locations.state' => state,
        :'us_states.abbreviation' => state
      }}
    end
  }

  class << self
    def find_by_name(name)
      state, district = name.split('-')
      district = 0 if district == 'At_large'
      first(:conditions => {'congressional_districts.district' => district, 'us_states.abbreviation' => state}, :joins => :state)
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
    @district_geometry ||= District.federal.scoped(:conditions => {
      :us_state_id => us_state_id, :name => district_abbreviation})
  end

  def district_abbreviation
    at_large? || unidentified? ? 'At large' : self[:district].to_s
  end

  def abbreviation
    "#{state.abbreviation}-#{district_abbreviation}"
  end

  def to_param
    abbreviation.gsub(' ', '_')
  end

  def unidentified?
    self[:district] == nil
  end

  def at_large?
    self[:district] == 0
  end

  def which
    if unidentified?
      'Unidentified'
    elsif at_large?
      'At-large'
    else
      self[:district].ordinalize
    end
  end
end
