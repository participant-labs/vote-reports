class ReportFollow < ActiveRecord::Base
  belongs_to :report
  belongs_to :user

  validates_presence_of :report, :user
  validates_uniqueness_of :report_id, :scope => :user_id

  after_create :add_to_personalized_report
  after_destroy :remove_from_personalized_report

private

  def add_to_personalized_report
    (user.personalized_report || user.reports.create(:state => 'personalized')).reports << report
    user.personalized_report.rescore!
  end

  def remove_to_personalized_report
    user.personalized_report.report_criteria.find_by_report_id(report).destroy
    user.personalized_report.rescore!
  end
end
