class AtLargeDistrictsAreDistrict0 < ActiveRecord::Migration
  def self.up
    Politician.representatives.in_office.paginated_each do |politician|
      district = politician.current_office.congressional_district
      if district.at_large?
        District.federal.update_all({:name => 'At large'}, {:us_state_id => district.us_state_id, :name => '1'})
      end
    end
  end

  def self.down
    raise 'nope'
  end
end
