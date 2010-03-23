class InterestGroup < ActiveRecord::Base
  has_ancestry

  belongs_to :subject
  has_many :reports, :class_name => 'InterestGroupReport'
  has_many :ratings, :through => :reports
  def rated_politicians
    Politician.scoped(
      :select => 'DISTINCT politicians.*',
      :joins => {:ratings => :reports},
      :conditions => {:'reports.interest_group_id' => self})
  end

  validates_presence_of :subject
  validate :ensure_subject_has_vote_smart_id

  def ensure_subject_has_vote_smart_id
    if subject && subject.vote_smart_id.blank?
      errors.add(:subject, 'does not have vote smart id')
    end
  end
end
