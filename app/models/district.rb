class District < ActiveRecord::Base
  belongs_to :state, :class_name => 'UsState', :foreign_key => :us_state_id
  has_many :district_zip_codes
  has_many :zip_codes, :through => :district_zip_codes

  has_many :representative_terms
  has_many :representatives, :through => :representative_terms, :source => :politician, :uniq => true do
    def in_office
      scoped(:conditions => ['politicians.current_office_type = ?', 'RepresentativeTerm'])
    end
  end
  has_many :cached_politicians, :class_name => 'Politician'

  delegate :senators, :to => :state

  named_scope :with_zip, lambda {|zip_code|
    zip_code, plus_4 = zip_code.to_s.match(/(?:^|[^\d])(\d\d\d\d\d)[-\s]*(\d{0,4})\s*$/).try(:captures)
    if zip_code.blank?
      {:conditions => '0 = 1'}
    elsif plus_4.blank?
      {:joins => :zip_codes, :conditions => {:'zip_codes.zip_code' => zip_code}}
    elsif DistrictZipCode.scoped(:joins => :zip_code, :conditions => {
        :'zip_codes.zip_code' => zip_code, :'district_zip_codes.plus_4' => plus_4
      }).exists?
      {:joins => :zip_codes, :conditions => {
        :'zip_codes.zip_code' => zip_code, :'district_zip_codes.plus_4' => plus_4
      }}
    else
      {:joins => :zip_codes, :conditions => [
        "zip_codes.zip_code = ? AND (district_zip_codes.plus_4 = ? OR district_zip_codes.plus_4 IS NULL)", zip_code, plus_4
      ]}
    end
  }

  named_scope :for_city, lambda {|address|
    city, state = address.upcase.split(', ', 2)
    if city.blank?
      {:conditions => '0 = 1'}
    elsif state.blank?
      {:select => 'DISTINCT districts.*',
      :joins => {:zip_codes => :locations},
      :conditions => {:'locations.city' => city}}
    else
      {:select => 'DISTINCT districts.*',
      :joins => {:zip_codes => :locations},
      :conditions => {:'locations.city' => city, :'locations.state' => state}}
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
    district_abbrv = at_large? || district.nil? ? 'At large' : self.district.to_s
    "#{state.abbreviation}-#{district_abbrv}"
  end

  def to_param
    abbreviation.gsub(' ', '_')
  end

  def at_large?
    district == 0
  end

  def which
    if district.nil?
      'Unidentified'
    elsif at_large?
      'At-large'
    else
      district.ordinalize
    end
  end
end
