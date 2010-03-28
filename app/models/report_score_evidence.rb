class ReportScoreEvidence < ActiveRecord::Base
  belongs_to :evidence, :polymorphic => true
  belongs_to :criterion, :polymorphic => true
  belongs_to :score, :class_name => 'ReportScore'

  # validates_presence_of :evidence, :score, :criterion
  delegate :subject, :to => :evidence
end
