class PresidentialTerm < ActiveRecord::Base
  include Term

  def for
    'the President of these United States'
  end
end
