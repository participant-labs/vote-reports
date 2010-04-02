class InterestGroupReport < ActiveRecord::Base
  belongs_to :interest_group
  has_many :ratings, :class_name => 'InterestGroupRating'

  validates_presence_of :interest_group
  validates_uniqueness_of :vote_smart_id

  def rated_on
    year = timespan.split('-').last
    season, year =
      if year.include?(' ')
        year.split(' ')
      else
        ['Spring', year]
      end
    Date.parse([season_midpoint(season), year].join('/'))
  end

  def vote_smart_url
    "http://votesmart.org/issue_rating_detail.php?r_id=#{vote_smart_id}"
  end

  private

  def season_midpoint(season)
    case season
    when 'Spring'
      "3/20"
    when 'Summer'
      "6/21"
    when 'Fall'
      "9/23"
    when 'Winter'
      "12/21"
    else
      raise "Unknown season: #{season.inspect}"
    end
  end
end
