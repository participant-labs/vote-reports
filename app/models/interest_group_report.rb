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
    ratings.numeric.select('numeric_rating, id, politician_id, interest_group_report_id').includes(:interest_group_report)
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
  }

  ALL_LETTER_GRADES = [
    'F--',
    'F-',
    'F',
    'F+',
    'D-',
    'D',
    'D+',
    'C-',
    'C',
    'C+',
    'B-',
    'B',
    'B+',
    'A-',
    'A',
    'A+'
  ]

  scope :with_zero_centered_ratings, select('DISTINCT interest_group_reports.*').joins(:ratings)\
    .where(:'interest_group_ratings.rating' => ZERO_CENTERED_RATINGS)

  class << self
    def calibrate_ratings
      paginated_each {|ig_report| ig_report.calibrate_ratings }
    end
  end

  def calibrate_ratings
    ratings.update_all(:numeric_rating => nil)

    calibrate_unusual_ratings
    calibrate_zero_centered_ratings
    calibrate_letter_ratings
    calibrate_normal_ratings

    interest_group.rescore!
  end

  private

  def calibrate_unusual_ratings
    UNUSUAL_RATINGS_MAP.each_pair do |rating, numeric_rating|
      ratings.update_all({:numeric_rating => numeric_rating}, {:rating => rating})
    end
  end

  def calibrate_letter_ratings
    if ratings.exists?(:rating => ALL_LETTER_GRADES)
      rating_values = ratings.all(:conditions => {:rating => ALL_LETTER_GRADES}).map(&:rating).uniq.sort.reverse
      options =
        if rating_values.join.include?('-') || rating_values.join.include?('+')
          case rating_values.first
          when 'F-'
            ['F-', 'F', 'F+', 'D-', 'D', 'D+', 'C-', 'C', 'C+', 'B-', 'B', 'B+', 'A-', 'A', 'A+']
          when 'F--'
            ALL_LETTER_GRADES
          else
            ['F', 'D-', 'D', 'D+', 'C-', 'C', 'C+', 'B-', 'B', 'B+', 'A-', 'A', 'A+']
          end
        else
          ["F", "D", "C", "B", "A"]
        end

      step = 100.0 / (options.size - 1)
      options.each_with_index do |letter, index|
        ratings.update_all({:numeric_rating => index * step}, {:rating => letter})
      end
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
  end

  def calibrate_normal_ratings
    ratings.all(:select => 'distinct rating', :conditions => ['numeric_rating IS NULL AND rating NOT IN(?)', NON_RATINGS]).map(&:rating).each do |rating|
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

      ratings.update_all(
        {:numeric_rating => numeric_rating}, {:rating => rating, :numeric_rating => nil})
      $stdout.print '.'
    end
  end

  def season_midpoint(season)
    case season
    when 'Spring'
      "20/3"
    when 'Summer'
      "21/6"
    when 'Fall'
      "23/9"
    when 'Winter'
      "21/12"
    else
      raise "Unknown season: #{season.inspect}"
    end
  end
end
