class InterestGroupRating < ActiveRecord::Base
  belongs_to :interest_group
  belongs_to :politician

  validates_presence_of :interest_group, :politician
end
