class MoveSenateTermsOver < ActiveRecord::Migration
  def self.up
    expected = PoliticianTerm.count(:conditions => {:type => 'SenateTerm'})
    raise '0' if expected == 0
    PoliticianTerm.all(:conditions => {:type => 'SenateTerm'}).each do |term|
      SenateTerm.create!(:politician => term.politician, :started_on => term.started_on, :ended_on => term.ended_on, :party => term.party, :url => term.url, :senate_class => term.senate_class, :state => term.state)
    end
    raise "not all" if SenateTerm.count != expected
    PoliticianTerm.delete_all(:type => 'SenateTerm')
  end

  def self.down
  end
end
