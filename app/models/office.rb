class Office < ActiveRecord::Base
  has_many :races
  belongs_to :office_type

  class << self
    def us_house
      find_by_vote_smart_id(5)
    end

    def state_senate
      find_by_vote_smart_id(9)
    end

    def state_lower
      all(:conditions => {:vote_smart_id => [7, 8]})
    end

    def districted
      all(:conditions => {:vote_smart_id => [5, 7, 8, 9]})
    end
  end
end
