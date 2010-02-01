class UsState < ActiveRecord::Base
  def unincorporated?
    state_type != 'state'
  end

  has_many :politician_terms
  alias_attribute :terms, :politician_terms

  has_many :representative_terms
  has_many :representatives, :through => :representative_terms, :source => :politician

  has_many :senate_terms
  has_many :senators, :through => :senate_terms, :source => :politician
end