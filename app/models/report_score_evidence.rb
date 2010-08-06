class ReportScoreEvidence < ActiveRecord::Base
  TYPE_NAMES = {
    'InterestGroupRating' => 'rating'
  }

  belongs_to :evidence, :polymorphic => true
  belongs_to :criterion, :polymorphic => true
  belongs_to :score, :class_name => 'ReportScore'

  named_scope :interest_group_ratings, :conditions => {:criterion_type => 'InterestGroupReport'}
  named_scope :not_interest_group_ratings, :conditions => ["report_score_evidences.criterion_type !=  ?", 'InterestGroupReport']

  # validates_presence_of :evidence, :score, :criterion
  delegate :subject, :to => :evidence

  class << self
    def type_name(type_name)
      TYPE_NAMES.fetch(type_name, type_name.underscore.humanize.downcase)
    end
  end
end
