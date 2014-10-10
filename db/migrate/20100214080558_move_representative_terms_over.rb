class MoveRepresentativeTermsOver < ActiveRecord::Migration
  def self.up
    $stdout.sync = true

    change_column :districts, :district, :integer, :null => true
    expected = PoliticianTerm.count(:conditions => {:type => 'RepresentativeTerm'})
    raise '0' if expected == 0
    PoliticianTerm.all(:conditions => {:type => 'RepresentativeTerm'}).each do |term|
      district = District.find_or_create_by(district: term.district, us_state_id: term.us_state_id)
      RepresentativeTerm.create!(:politician => term.politician, :started_on => term.started_on, :ended_on => term.ended_on, :party => term.party, :url => term.url, :district => district)
      $stdout.print '.'
    end
    raise "not all" if RepresentativeTerm.count != expected
    PoliticianTerm.delete_all(:type => 'RepresentativeTerm')
  end

  def self.down
  end
end
