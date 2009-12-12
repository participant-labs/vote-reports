class Politician < ActiveRecord::Base
  include Politician::GovTrack
  include Politician::SunlightLabs

  has_many :representative_terms
  has_many :senate_terms

  CONTACT_FIELDS = [:twitter_id, :email].freeze

  validates_length_of CONTACT_FIELDS, :minimum => 1, :allow_nil => true
  validates_uniqueness_of CONTACT_FIELDS, :allow_nil => true
  validate :name_shouldnt_contain_nickname

  has_many :votes
  has_many :bills, :through => :votes do
    def supported
      scoped(:conditions => "votes.vote = true")
    end
    def opposed
      scoped(:conditions => "votes.vote = false")
    end
  end

  def full_name= full_name
    self.last_name, self.first_name = full_name.split(', ',2)
  end

  def full_name
    [first_name, last_name].join(" ")
  end

  private

  def name_shouldnt_contain_nickname
    errors.add(:first_name, "shouldn't contain nickname") if first_name =~ /\s?(.+)\s'(.+)'\s?/
  end
end
