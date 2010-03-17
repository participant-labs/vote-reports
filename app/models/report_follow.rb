class ReportFollow < ActiveRecord::Base
  belongs_to :report
  belongs_to :user

  validates_presence_of :report, :user
  validates_uniqueness_of :report_id, :scope => :user_id
  validate :user_isnt_report_creator

  private

  def user_isnt_report_creator
    if user == report.user
      errors.add(:user, "is already following this report")
    end
  end
end
