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

  NON_RATINGS = ['', 'NA', 'N/A', 'n/a', 'S', 'Inc.', '24970']

  PLUS_RATINGS = ["+1", "+10", "+11", "+12", "+2", "+3", "+4", "+5", "+6", "+7", "+8", "+9"]
  ZERO_CENTERED_RATINGS = PLUS_RATINGS + ["-1", "-10", "-11", "-12", "-13", "-14", "-15", "-16", "-17", "-18", "-19", "-2", "-2(House)/-1(Senator)", "-20", "-21", "-22", "-23", "-24", "-25", "-26", "-28", "-3", "-30", "-31", "-33", "-34", "-35", "-36", "-38", "-4", "-40", "-41", "-42", "-43", "-44", "-45", "-48", "-49", "-5", "-52", "-53", "-54", "-55", "-57", "-59", "-6", "-60", "-62", "-64", "-66", "-67", "-68", "-7", "-71", "-72", "-74", "-76", "-8", "-81", "-86", "-9"]

  UNUSUAL_RATINGS_MAP = {
    '00' => 0.0,
    '000' => 0.0,
    '0+' => 0.0,
    "06" => 6.0,
    '12.' => 12.0,
    "014" => 14.0,
    "029" => 29.0,
    '033' => 33.0,
    '014' => 14.0,
    '029' => 29.0,
    '033' => 33.0,

    '71`' => 71.0,
    '87+' => 87.0,
    '100+' => 100.0,
    '100.' => 100.0,
    '100`' => 100.0,
    "0100" => 100.0,

    '102' => 100.0,
    '103' => 100.0,
    '104' => 100.0,
    '105' => 100.0,
    '108' => 100.0,
    '110' => 100.0,
    '116' => 100.0,
    '117' => 100.0,

    'Anti Hemp' => 0.0,
    'Fence Sitter' => 50.0,
    'Pro Hemp' => 100.0, 

    'F--' => 0.0,
    'F-' => 6.6667,
    'F' => 13.3333,
    'F+' => 20.0,
    'D-' => 26.6667,
    'D' => 33.3333,
    'D+' => 40.0,
    'C-' => 46.6667,
    'C' => 53.3333,
    'C+' => 60.0,
    'B-' => 66.6667,
    'B' => 73.3333,
    'B+' => 80.0,
    'A-' => 86.6667,
    'A' => 93.3333,
    'A+' => 100.0
  }

  named_scope :with_zero_centered_ratings, :select => 'DISTINCT interest_group_reports.*', :joins => :ratings,
    :conditions => {:'interest_group_ratings.rating' => ZERO_CENTERED_RATINGS}

  class << self
    def calibrate_ratings
      paginated_each {|ig_report| ig_report.calibrate_ratings }
    end
  end

  def calibrate_ratings
    calibrate_unusual_ratings
    calibrate_zero_centered_ratings
    calibrate_normal_ratings
  end

  def calibrate_unusual_ratings
    UNUSUAL_RATINGS_MAP.each_pair do |rating, numeric_rating|
      ratings.update_all({:numeric_rating => numeric_rating}, {:rating => rating})
    end
  end

  def calibrate_zero_centered_ratings
    return unless ratings.exists?(:rating => ZERO_CENTERED_RATINGS)

    rating_values = ratings.map {|r| r.rating.to_f }
    if rating_values.max >= 100.0
      # the negatives are just outliers, not a sign of a 0-centered range
      if (ratings.map(&:rating) & PLUS_RATINGS).present?
        raise "Unexpected + rating in #{vote_smart_id} which we assumed was a normal range"
      end
      $stdout.print 'G'
      ratings.update_all({:numeric_rating => 0.0}, {:rating => ZERO_CENTERED_RATINGS})
    else
      # this is a range centered around 0
      abs_min = -rating_values.min
      max = [rating_values.max, abs_min].max
      step = 100 / (max + abs_min)
      $stdout.print 'R'
      ratings.each do |rating|
        r = (rating.rating == "-2(House)/-1(Senator)" ? -1.5 : rating.rating.to_f)
        rating.update_attribute(:numeric_rating, (r + abs_min) * step)
      end
    end
    interest_group.rescore!
  end

  def calibrate_normal_ratings
    ratings.all(:conditions => ['numeric_rating IS NULL AND rating NOT IN(?)', NON_RATINGS]).map(&:rating).each do |rating|
      numeric_rating = 
        begin
          if rating.match(/^[+-]+$/)
            rating.count('+').to_f / rating.size
          elsif rating.match(/^[ny]+$/)
           rating.count('y').to_f / rating.size
          elsif rating.match(/^[rw]+$/)
            rating.count('r').to_f / rating.size
          else
            Float(rating)
          end
        rescue ArgumentError
          puts "Bad value: #{rating}" unless Rails.env.production?
          raise
        end

      InterestGroupRating.update_all(
        {:numeric_rating => numeric_rating}, {:rating => rating})
      $stdout.print '.'
    end
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
