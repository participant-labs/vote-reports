class ReportScore < ActiveRecord::Base
  belongs_to :report
  belongs_to :politician
  has_many :evidence, :class_name => 'ReportScoreEvidence'
end
