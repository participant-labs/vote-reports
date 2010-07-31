class ReportScoreEvidence < ActiveRecord::Base
  belongs_to :evidence, :polymorphic => true
  belongs_to :criterion, :polymorphic => true
  belongs_to :score, :class_name => 'ReportScore'

  named_scope :interest_group_ratings, :conditions => {:criterion_type => 'InterestGroupReport'}
  named_scope :votes, :conditions => {:criterion_type => 'BillCriterion'}

  # validates_presence_of :evidence, :score, :criterion
  delegate :subject, :to => :evidence
end
