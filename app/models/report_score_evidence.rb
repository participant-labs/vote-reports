class ReportScoreEvidence < ActiveRecord::Base
  belongs_to :vote
  belongs_to :score, :class_name => 'ReportScore'
  belongs_to :bill_criterion
  has_one :roll, :through => :vote
  delegate :subject, :to => :roll
end
