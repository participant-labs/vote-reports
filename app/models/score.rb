module Score
  LETTER_GRADES = %w[A B C D F].flat_map {|letter| ["#{letter}+", letter, "#{letter}-"] }.reverse.freeze

  def letter_grade(for_score = score)
    grade_index = (for_score / (100.0 / LETTER_GRADES.size)).floor
    #this is a hack to deal with the edge case of 100.  really we should account for it above
    if grade_index >= LETTER_GRADES.size && for_score == 100.0
      LETTER_GRADES.last
    else
      raise inspect if grade_index > LETTER_GRADES.size - 1
      LETTER_GRADES.fetch(grade_index)
    end
  end

  def opposition_letter_grade
    letter_grade(opposition_score)
  end

  def percentage
    "#{score.round}%"
  end
end
