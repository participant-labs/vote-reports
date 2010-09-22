class Candidacy < ActiveRecord::Base
  belongs_to :politician
  belongs_to :race

  named_scope :valid, :conditions => ['status NOT IN(?)', ["Deceased", "Withdrawn", "Removed"]]
end
