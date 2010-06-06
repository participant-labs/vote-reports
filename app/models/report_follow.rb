class ReportFollow < ActiveRecord::Base
  belongs_to :report
  belongs_to :user

  validates_presence_of :report, :user
  validates_uniqueness_of :report_id, :scope => :user_id
end