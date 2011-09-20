class ReportScoreEvidence < ActiveRecord::Base
  TYPE_NAMES = {
    'InterestGroupRating' => 'rating'
  }

  belongs_to :evidence, polymorphic: true
  belongs_to :criterion, polymorphic: true
  belongs_to :score, class_name: 'ReportScore', foreign_key: 'report_score_id'

  scope :interest_group_ratings, where(criterion_type: 'InterestGroupReport')
  scope :not_interest_group_ratings, where(["report_score_evidences.criterion_type !=  ?", 'InterestGroupReport'])

  # validates_presence_of :evidence, :score, :criterion
  delegate :subject, to: :evidence

  class << self
    def type_name(type_name)
      TYPE_NAMES.fetch(type_name, type_name.underscore.humanize.downcase)
    end
  end
end
