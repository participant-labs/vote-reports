class Office < ActiveRecord::Base
  has_many :races
  belongs_to :office_type

  scope :state_lower, -> { where(vote_smart_id: [7, 8]) }
  scope :districted, -> { where(vote_smart_id: [5, 7, 8, 9]) }

  class << self
    def us_house
      find_by_vote_smart_id(5)
    end

    def state_senate
      find_by_vote_smart_id(9)
    end
  end
end
