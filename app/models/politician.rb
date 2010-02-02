class Politician < ActiveRecord::Base
  include Politician::GovTrack
  include Politician::SunlightLabs

  has_friendly_id :full_name, :use_slug => true

  has_many :representative_terms
  has_many :senate_terms
  has_many :presidential_terms
  has_many :politician_terms
  alias_attribute :terms, :politician_terms

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

  named_scope :with_name, lambda {|name|
    first, last = name.split(' ', 2)
    {:conditions => {:first_name => first, :last_name => last}}
  }
  named_scope :by_birth_date, :order => 'birthday DESC NULLS LAST'
  named_scope :from_state, lambda {|state|
    state = UsState.first(:conditions => ["abbreviation = :state OR UPPER(full_name) = :state", {:state => state.upcase}]) if state.is_a?(String)
    if state
      {:select => 'DISTINCT politicians.*', :conditions => {:'politician_terms.us_state_id' => state}, :joins => :politician_terms}
    else
      {:conditions => '0 = 1'}
    end
  }

  class << self
    def from_zip_code(zip_code)
      District.with_zip(zip_code).first.try(:politicians)
    end

    def from(from_where)
      results = from_state(from_where)
      results = from_zip_code(from_where) if results.blank?

      if results.blank?
        location = Geokit::Geocoders::MultiGeocoder.geocode(from_where)
        if location.zip.present?
          results = from_zip_code(location.zip)
        elsif location.state.present?
          results = from_state(location.state)
        end
      end

      results
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
