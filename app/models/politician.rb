class Politician < ActiveRecord::Base
  include Politician::GovTrack
  include Politician::SunlightLabs

  has_friendly_id :full_name, :use_slug => true, :strip_diacritics => true

  has_many :representative_terms
  has_many :senate_terms
  has_many :presidential_terms

  def latest_term
    [representative_terms.by_ended_on.first,
      senate_terms.by_ended_on.first,
      presidential_terms.by_ended_on.first].compact.sort_by(&:ended_on).reverse.first
  end

  belongs_to :state, :class_name => 'UsState', :foreign_key => :us_state_id

  IDENTITY_STRING_FIELDS = [
    :vote_smart_id, :bioguide_id, :eventful_id, :twitter_id, :email, :metavid_id,
    :congresspedia_url, :open_secrets_id, :crp_id, :fec_id, :phone, :website, :youtube_url
  ].freeze
  IDENTITY_INTEGER_FIELDS = [:gov_track_id].freeze
  IDENTITY_FIELDS = (IDENTITY_STRING_FIELDS | IDENTITY_INTEGER_FIELDS).freeze

  validates_length_of IDENTITY_STRING_FIELDS, :minimum => 1, :allow_nil => true
  validates_uniqueness_of IDENTITY_FIELDS, :allow_nil => true

  validate :name_shouldnt_contain_nickname
  before_validation :extract_nickname_from_first_name_if_present

  has_many :votes
  has_many :rolls, :through => :votes, :extend => Vote::Support

  has_many :bill_supports
  has_many :supported_bills, :through => :bill_supports, :source => :bill
  has_many :bill_oppositions
  has_many :opposed_bills, :through => :bill_oppositions, :source => :bill

  has_many :report_scores
  has_many :reports, :through => :report_scores

  named_scope :in_office, lambda {
    {
      :select => 'DISTINCT politicians.*',
      :joins => [
        %{LEFT OUTER JOIN "representative_terms" ON representative_terms.politician_id = politicians.id},
        %{LEFT OUTER JOIN "senate_terms" ON senate_terms.politician_id = politicians.id},
        %{LEFT OUTER JOIN "presidential_terms" ON presidential_terms.politician_id = politicians.id}],
      :conditions => [
        '(((representative_terms.started_on, representative_terms.ended_on) OVERLAPS (DATE(:yesterday), DATE(:tomorrow))) OR ' \
        '((senate_terms.started_on, senate_terms.ended_on) OVERLAPS (DATE(:yesterday), DATE(:tomorrow))) OR ' \
        '((presidential_terms.started_on, presidential_terms.ended_on) OVERLAPS (DATE(:yesterday), DATE(:tomorrow))))',
      {:yesterday => Date.yesterday, :tomorrow => Date.tomorrow}
    ]}
  }
  named_scope :with_name, lambda {|name|
    first, last = name.split(' ', 2)
    {:conditions => {:first_name => first, :last_name => last}}
  }
  named_scope :by_birth_date, :order => 'birthday DESC NULLS LAST'
  named_scope :from_district, lambda {|districts|
    {:conditions => [
        "(senate_terms.us_state_id IN(?) OR representative_terms.district_id IN(?))",
         Array(districts).map(&:us_state_id), districts
      ], :joins => [
        %{LEFT OUTER JOIN "representative_terms" ON representative_terms.politician_id = politicians.id},
        %{LEFT OUTER JOIN "senate_terms" ON senate_terms.politician_id = politicians.id},
      ], :select => 'DISTINCT politicians.*'
    }
  }
  named_scope :from_state, lambda {|state|
    state = UsState.first(:conditions => ["abbreviation = :state OR UPPER(full_name) = :state", {:state => state.upcase}]) if state.is_a?(String)
    if state
      {:select => 'DISTINCT politicians.*', :conditions => [
        'senate_terms.us_state_id = ? OR districts.us_state_id = ?', state, state
      ], :joins => [
        %{LEFT OUTER JOIN "representative_terms" ON representative_terms.politician_id = politicians.id},
        %{LEFT OUTER JOIN "senate_terms" ON senate_terms.politician_id = politicians.id},
        %{LEFT OUTER JOIN "districts" ON representative_terms.district_id = districts.id},
      ]}
    else
      {:conditions => '0 = 1'}
    end
  }

  class << self
    def from_zip_code(zip_code)
      from_district(District.with_zip(zip_code))
    end

    def from_location(state = nil, zip_code = nil)
      if zip_code.present?
        from_zip_code(zip_code)
      elsif state.present?
        from_state(state)
      end
    end

    def from(from_where)
      if from_where.is_a?(Geokit::GeoLoc)
        from_location(from_where.state, from_where.zip)
      else
        results = from_state(from_where)
        results = from_zip_code(from_where) if results.blank?

        if results.blank?
          location = Geokit::Geocoders::MultiGeocoder.geocode(from_where)
          results = from_location(location.state, location.zip)
        end

        results
      end
    end
  end

  def full_name= full_name
    self.last_name, self.first_name = full_name.split(', ', 2)
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  def short_title
    return '' if title.blank?
    if title == 'President'
      'Pres.'
    else
      "#{title.to(2)}."
    end
  end

  private

  def name_shouldnt_contain_nickname
    errors.add(:first_name, "shouldn't contain nickname") if first_name =~ /\s?(.+)\s'(.+)'\s?/
  end

  def extract_nickname_from_first_name_if_present
    if first_name =~ /\s?(.+)\s'(.+)'\s?/
      self.first_name = $1
      self.nickname = $2
    end
  end
end
