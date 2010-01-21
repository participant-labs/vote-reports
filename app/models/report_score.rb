class ReportScore < ActiveRecord::Base
  belongs_to :report
  has_many :evidence, :class_name => 'ReportScoreEvidence'
end
