class ReportFollow < ActiveRecord::Base
  belongs_to :report
  belongs_to :user

  after_create :rescore_personal_report

  validates_presence_of :report, :user
  validates_uniqueness_of :report_id, :scope => :user_id

  private

  def rescore_personal_report
    (user.personal_report || user.build_personal_report(:name => 'Personal Report', :state => 'personal')).tap(&:save!).rescore!
  end
end
