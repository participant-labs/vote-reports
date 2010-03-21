class InterestGroup < ActiveRecord::Base
  has_ancestry

  has_many :interest_group_ratings
  has_many :rated_politicians, :through => :interest_group_ratings, :source => :politician
end
