class PresidentialTerm < ActiveRecord::Base
  belongs_to :politician

  validates_presence_of :politician, :party

  def for
    'the President of these United States'
  end
end
