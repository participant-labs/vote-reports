class ReportFollow < ActiveRecord::Base
  belongs_to :report
  belongs_to :user

  validates_presence_of :report, :user
  validates_uniqueness_of :report, :scope => :user
end
