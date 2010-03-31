class InterestGroupRating < ActiveRecord::Base
  belongs_to :interest_group_report
  belongs_to :politician

  delegate :interest_group, :to => :interest_group_report

  validates_presence_of :interest_group_report, :politician

  named_scope :numeric, :conditions => 'interest_group_ratings.numeric_rating IS NOT NULL'

  def subject
    interest_group_report
  end
end
