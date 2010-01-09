require 'term'

class PresidentialTerm < ActiveRecord::Base
  acts_as_term

  def for
    'the President of these United States'
  end
end
