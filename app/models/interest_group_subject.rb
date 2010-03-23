class InterestGroupSubject < ActiveRecord::Base
  belongs_to :interest_group
  belongs_to :subject

  validates_presence_of :interest_group, :subject
  validate :ensure_subject_has_vote_smart_id

private
  def ensure_subject_has_vote_smart_id
    if subject && subject.vote_smart_id.blank?
      errors.add(:subject, 'does not have vote smart id')
    end
  end
end
