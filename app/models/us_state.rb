class UsState < ActiveRecord::Base
  def unincorporated?
    state_type != 'state'
  end

  has_friendly_id :abbreviation

  has_many :districts
  has_many :representative_terms, :through => :districts
  def representatives
    Politician.representatives_from_state(self)
  end

  def representatives_in_office
    representatives.scoped(:conditions => ['politicians.current_office_type = ?', 'RepresentativeTerm'])
  end

  has_many :senate_terms
  has_many :senators, :through => :senate_terms, :source => :politician, :uniq => true do
    def in_office
      scoped(:conditions => ['politicians.current_office_type = ?', 'SenateTerm'])
    end
  end
end
