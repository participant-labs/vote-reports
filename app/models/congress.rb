class Congress < ActiveRecord::Base
  has_many :bills, dependent: :destroy
  has_many :amendments, through: :bills
  has_many :rolls
  has_many :committee_meetings

  validates_uniqueness_of :meeting

  class << self
    def current_meeting
      today = Date.today
      meeting = (today.year - 1787) / 2
      meeting -= 1 if today.month == 1 && today.day < 3
      meeting
    end

    def current
      first(conditions: {meeting: current_meeting})
    end
  end

  def current?
    meeting == Congress.current_meeting
  end
end