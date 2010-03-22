class InterestGroupReport < ActiveRecord::Base
  belongs_to :interest_group
  has_many :ratings, :class_name => 'InterestGroupRating'

  validates_presence_of :interest_group
  validates_uniqueness_of :timespan, :scope => :interest_group_id
  validates_uniqueness_of :vote_smart_id
end
