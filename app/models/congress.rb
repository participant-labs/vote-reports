class Congress < ActiveRecord::Base
  has_many :representative_terms
  has_many :representatives, :through => :representative_terms, :source => :politician

  has_many :senate_terms
  has_many :senators, :through => :senate_terms, :source => :politician
end