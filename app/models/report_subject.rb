class ReportSubject < ActiveRecord::Base
  belongs_to :report
  belongs_to :subject

  # constraints on db:
  # report, subject presence
  # [report, subject] uniqueness

  class << self
    def generate_for(report)
      report.report_subjects.delete_all
      bill_criteria_subjects = report.bill_criteria_subjects.scoped(
        :select => "DISTINCT(subjects.id), COUNT(subjects.id) AS count",
        :group => 'subjects.id').inject({}) do |hash, subject|
        hash[subject] = subject.count
        hash
      end

      if report.interest_group
        count = report.interest_group.reports.count
        report.interest_group.subjects.each do |subject|
          bill_criteria_subjects[subject] ||= 0
          bill_criteria_subjects[subject] += count
        end
      end

      if bill_criteria_subjects.present?
        ReportSubject.import_without_validations_or_callbacks(
          [:report_id, :subject_id, :count],
          bill_criteria_subjects.map do |(subject, count)|
            [report.id, subject.id, count]
          end
        )
      end
    end

    def generate!
      require 'ar-extensions'
      require 'ar-extensions/import/postgresql'

      transaction do
        paginated_each do |report|
          generate_for(report)
        end
      end
    end
  end
end
