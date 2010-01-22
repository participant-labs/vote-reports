class ReportScoreEvidence < ActiveRecord::Base
  belongs_to :vote
  belongs_to :score, :class_name => 'ReportScore'
  belongs_to :bill_criterion

  delegate :roll, :to => :vote
  delegate :subject, :to => :roll
end
