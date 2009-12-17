class Congress < ActiveRecord::Base
  has_many :representative_terms, :dependent => :destroy
  has_many :representatives, :through => :representative_terms, :source => :politician

  has_many :senate_terms, :dependent => :destroy
  has_many :senators, :through => :senate_terms, :source => :politician

  has_many :bills, :dependent => :destroy
end