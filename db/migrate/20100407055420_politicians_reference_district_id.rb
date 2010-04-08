class PoliticiansReferenceDistrictId < ActiveRecord::Migration
  def self.up
    $stdout.sync = true
    rename_column :politicians, :district, :district_id
    Politician.update_all(:district_id => nil, :us_state_id => nil)
    Politician.paginated_each(:select => 'DISTINCT politicians.*', :joins => :latest_senate_term) do |politician|
      term = politician.latest_term
      if term.respond_to?(:district)
        politician.update_attributes :district => term.district, :state => term.state
      elsif term.respond_to?(:state)
        politician.update_attributes :district => nil, :state => term.state
      end
      $stdout.print '.'
    end
    Politician.paginated_each(:select => 'DISTINCT politicians.*', :joins => :latest_representative_term) do |politician|
      term = politician.latest_term
      if term.is_a?(RepresentativeTerm)
        politician.update_attributes :district => term.district, :state => term.state
      elsif term.is_a?(SenateTerm)
        politician.update_attributes :district => nil, :state => term.state
      end
      $stdout.print '.'
    end
    constrain :politicians, :district_id, :reference => {:districts => :id}
  end

  def self.down
    deconstrain :politicians, :district_id, :reference
    rename_column :politicians, :district_id, :district
  end
end
