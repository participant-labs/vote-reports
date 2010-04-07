class PoliticiansReferenceDistrictId < ActiveRecord::Migration
  def self.up
    $stdout.sync = true
    rename_column :politicians, :district, :district_id
    Politician.update_all(:district_id => nil, :us_state_id => nil)
    Politician.scoped(:select => 'DISTINCT politicians.*', :joins => [:latest_senate_term, :latest_representative_term]).each do |politician|
      term = politician.latest_term
      if term.respond_to?(:district)
        politician.update_attribute :district, term.district
        politician.update_attribute :state, term.state
      elsif term.respond_to?(:state)
        politician.update_attribute :district, nil
        politician.update_attribute :state, term.state
      end
      $stdout.print '.'
    end
    constrain :politicians, :district_id, :reference => {:districts => :id}
  end

  def self.down
  end
end
