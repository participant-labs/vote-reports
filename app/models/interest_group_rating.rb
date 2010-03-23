class InterestGroupRating < ActiveRecord::Base
  belongs_to :interest_group_report
  belongs_to :politician

  validates_presence_of :interest_group_report, :politician
end
