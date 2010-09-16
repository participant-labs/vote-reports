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

  def events
    ratings.numeric.scoped(
      :select => 'numeric_rating, id, politician_id, interest_group_report_id',
      :include => :interest_group_report)
  end

  def event_score(rating)
    rating.numeric_rating
  end

  PLUS_RATINGS = ["+1", "+10", "+11", "+12", "+2", "+3", "+4", "+5", "+6", "+7", "+8", "+9"]
  ZERO_CENTERED_RATINGS = PLUS_RATINGS + ["-1", "-10", "-11", "-12", "-13", "-14", "-15", "-16", "-17", "-18", "-19", "-2", "-2(House)/-1(Senator)", "-20", "-21", "-22", "-23", "-25", "-3", "-30", "-4", "-5", "-6", "-7", "-8", "-9"]

  class << self
    def calibrate_zero_centered_ratings
      InterestGroupReport.all(:select => 'DISTINCT interest_group_reports.*', :joins => :ratings,
        :conditions => {:'interest_group_ratings.rating' => ZERO_CENTERED_RATINGS}).each do |report|
        report.calibrate_zero_centered_ratings
      end
    end
  end

  def calibrate_zero_centered_ratings
    rating_values = ratings.map {|r| r.rating.to_f }
    if rating_values.max >= 100.0
      # the negatives are just outliers, not a sign of a 0-centered range
      if (ratings.map(&:rating) & PLUS_RATINGS).present?
        raise "Unexpected + rating in #{vote_smart_id} which we assumed was a normal range"
      end
      ratings.update_all({:numeric_rating => 0.0}, {:rating => ZERO_CENTERED_RATINGS})
    else
      # this is a range centered around 0
      max = [rating_values.max, -rating_values.min].max
      step = 100 / ((max * 2) + 1)
      $stdout.print 'R'
      ratings.each do |rating|
        r = (rating.rating == "-2(House)/-1(Senator)" ? -1.5 : rating.rating.to_f)
        rating.update_attribute(:numeric_rating, (r + max) * step)
      end
    end
    interest_group.rescore!
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
