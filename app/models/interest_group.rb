class InterestGroup < ActiveRecord::Base
  has_ancestry

  has_many :interest_group_subjects
  has_many :subjects, :through => :interest_group_subjects

  has_many :reports, :class_name => 'InterestGroupReport'
  has_many :ratings, :through => :reports
  def rated_politicians
    Politician.scoped(
      :select => 'DISTINCT politicians.*',
      :joins => {:ratings => :reports},
      :conditions => {:'reports.interest_group_id' => self})
  end
end
