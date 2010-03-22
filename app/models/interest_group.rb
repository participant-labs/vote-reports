class InterestGroup < ActiveRecord::Base
  has_ancestry

  belongs_to :subject
  has_many :interest_group_ratings
  has_many :rated_politicians, :through => :interest_group_ratings, :source => :politician

  validates_presence_of :subject
  validate :ensure_subject_has_vote_smart_id

  def ensure_subject_has_vote_smart_id
    if subject && subject.vote_smart_id.blank?
      errors.add(:subject, 'does not have vote smart id')
    end
  end
end
