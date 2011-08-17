class ReportSubject < ActiveRecord::Base
  belongs_to :report
  belongs_to :subject

  scope :by_count, order('count DESC')

  # constraints on db:
  # report, subject presence
  # [report, subject] uniqueness

  class << self
    def generate_for(report)
      ReportSubject.delete_all(:report_id => report.id)
      subjects = Hash[report.bill_criteria_subjects.select("DISTINCT(subjects.id), COUNT(subjects.id) AS count")\
        .group('subjects.id').map do |subject|
        [subject, Integer(subject.count)]
      end]

      if report.interest_group
        count = report.interest_group.reports.count
        report.interest_group.interest_group_subjects.each do |interest_group_subject|
          subjects[interest_group_subject.subject] ||= 0
          subjects[interest_group_subject.subject] += count
        end
      end

      if report.cause
        report.cause.reports.report_subjects.each do |report_subject|
          subjects[report_subject.subject] ||= 0
          subjects[report_subject.subject] += report_subject.count
        end
      end

      if subjects.present?
        ReportSubject.import_without_validations_or_callbacks(
          [:report_id, :subject_id, :count],
          subjects.map do |(subject, count)|
            [report.id, subject.id, count]
          end
        )
      end
      if top_report_subject = report.report_subjects.by_count.first
        report.update_attribute(:top_subject_id, top_report_subject.subject_id)
      end
    end

    def generate!
      transaction do
        Report.non_cause.paginated_each do |report|
          generate_for(report)
        end
        Report.for_causes.paginated_each do |report|
          generate_for(report)
        end
      end
    end
  end
end
