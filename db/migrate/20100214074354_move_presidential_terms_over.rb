class MovePresidentialTermsOver < ActiveRecord::Migration
  def self.up
    expected = PoliticianTerm.count(:conditions => {:type => 'PresidentialTerm'})
    raise '0' if expected == 0
    PoliticianTerm.all(:conditions => {:type => 'PresidentialTerm'}).each do |term|
      PresidentialTerm.create!(:politician => term.politician, :started_on => term.started_on, :ended_on => term.ended_on, :party => term.party, :url => term.url)
    end
    raise "not all" if PresidentialTerm.count != expected
    PoliticianTerm.delete_all(:type => 'PresidentialTerm')
  end

  def self.down
  end
end
