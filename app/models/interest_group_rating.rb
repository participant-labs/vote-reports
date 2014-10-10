class InterestGroupRating < ActiveRecord::Base
  belongs_to :interest_group_report
  belongs_to :politician

  delegate :interest_group, to: :interest_group_report

  validates_presence_of :interest_group_report, :politician
  validates_uniqueness_of :interest_group_report_id, scope: :politician_id

  scope :numeric, -> { where('interest_group_ratings.numeric_rating IS NOT NULL') }

  def event_date
    interest_group_report.rated_on
  end

  def subject
    interest_group_report
  end
end
