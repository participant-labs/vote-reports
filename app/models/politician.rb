class Politician < ActiveRecord::Base
  include Politician::GovTrack
  include Politician::SunlightLabs

  has_friendly_id :full_name, :use_slug => true

  has_many :representative_terms
  has_many :senate_terms
  has_many :presidential_terms
  has_many :politician_terms
  alias_attribute :terms, :politician_terms

  def state
    terms.latest(:joins => :state).try(:state)
  end

  def party
    terms.latest.try(:party) || Party.find_by_name('Independent')
  end

  def title
    terms.latest.try(:title)
  end

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

  def full_name= full_name
    self.last_name, self.first_name = full_name.split(', ', 2)
  end

  def full_name
    [first_name, last_name].join(" ")
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
