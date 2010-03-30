class AddNumericRatingToInterestGroupRatings < ActiveRecord::Migration
  NON_RATINGS = ['', 'N/A', 'n/a', 'S', 'Inc.']
  UNUSUAL_RATINGS_MAP = {
    '00' => 0.0,
    '000' => 0.0,
    '0+' => 0.0,
    "06" => 6.0,
    '12.' => 12.0,
    "014" => 14.0,
    "029" => 29.0,
    '033' => 33.0,
    '100+' => 100.0,
    '100.' => 100.0,
    '100`' => 100.0,
    "0100" => 100.0,

    '102' => 100.0,
    '103' => 100.0,
    '104' => 100.0,
    '105' => 100.0,
    '108' => 100.0,

    'Anti Hemp' => 0.0,
    'Fence Sitter' => 50.0,
    'Pro Hemp' => 100.0, 

    'F--' => 0.0,
    'F-' => 3.0,
    'F' => 10.0,
    'F+' => 17.0,
    'D-' => 24.0,
    'D' => 31.0,
    'D+' => 38.0,
    'C-' => 45.0,
    'C' => 52.0,
    'C+' => 59.0,
    'B-' => 66.0,
    'B' => 73.0,
    'B+' => 80.0,
    'A-' => 87.0,
    'A' => 94.0,
    'A+' => 100.0
  }
  PLUS_RATINGS = ["+1", "+10", "+11", "+12", "+2", "+3", "+4", "+5", "+6", "+7", "+8", "+9"]
  ZERO_CENTERED_RATINGS = PLUS_RATINGS + ["-1", "-10", "-11", "-12", "-13", "-14", "-15", "-16", "-17", "-18", "-19", "-2", "-2(House)/-1(Senator)", "-20", "-21", "-22", "-23", "-25", "-3", "-30", "-4", "-5", "-6", "-7", "-8", "-9"]

  def self.numeric_rating(rating)
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
  end

  def self.up
    $stdout.sync = true
    add_column :interest_group_ratings, :numeric_rating, :float
    constrain :interest_group_ratings, :numeric_rating, :within => 0.0...100.0

    UNUSUAL_RATINGS_MAP.each_pair do |rating, numeric_rating|
      InterestGroupRating.update_all({:numeric_rating => numeric_rating}, {:rating => rating})
    end

    InterestGroupReport.all(:select => 'DISTINCT interest_group_reports.*', :joins => :ratings,
      :conditions => {:'interest_group_ratings.rating' => ZERO_CENTERED_RATINGS}).each do |report|
      ratings = report.ratings.map {|r| r.rating.to_f }
      if ratings.max >= 100.0
        # the negatives are just outliers, not a sign of a 0-centered range
        if (report.ratings.map(&:rating) | PLUS_RATINGS).present?
          raise "Unexpected + rating in #{report.vote_smart_id} which we assumed was a normal range"
        end
        $stdout.print 'G'
        report.ratings.update_all({:numeric_rating => 0.0}, {:rating => ZERO_CENTERED_RATINGS})
      else
        # this is a range centered around 0
        max = [r.max, -r.min].max
        range = ((max * 2) + 1)
        $stdout.print 'R'
        report.ratings.each do |rating|
          rating.update_attribute(:numeric_rating, (rating.rating.to_f + max) * 100.0 / range))
        end
      end
    end

    InterestGroupRating.paginated_each(:conditions => 'numeric_rating IS NULL') do |rating|
      next if NON_RATINGS.include?(rating.rating)
      $stdout.print '.'
      rating.update_attribute(:numeric_rating, numeric_rating(rating.rating))
    end
  end

  def self.down
  end
end
