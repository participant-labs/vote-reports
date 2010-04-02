class ReportSubject < ActiveRecord::Base
  belongs_to :report
  belongs_to :subject

  # constraints on db:
  # report, subject presence
  # [report, subject] uniqueness
end
