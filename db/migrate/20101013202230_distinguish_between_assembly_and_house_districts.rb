class DistinguishBetweenAssemblyAndHouseDistricts < ActiveRecord::Migration
  def self.up
    add_column :districts, :title, :string

    say_with_time "Update district titles" do
      District.paginated_each do |district|
        if district.federal?
          district.update_attribute(:title, district.congressional_district.title)
        else
          race = district.state.races.send(district.level.level).first
          office_name =
            if race
              race.office.name
            elsif district.level.level == 'state_upper'
              'State Senate'
            elsif ['LA', 'MS', 'VA', 'NJ'].include?(district.state.abbreviation) && district.level.level == 'state_lower'
              'State House'
            elsif district.state.abbreviation == 'DC' && district.level.level == 'state_upper'
              'City Council'
            else
              puts "No office for district #{district.attributes.except('the_geom').inspect} #{district.state.inspect}"
              nil
            end
          next unless office_name
          district.update_attribute(:title, "#{district.ordinal_name} #{office_name} District")
        end
        print '.'
      end
      puts
    end
  end

  def self.down
    remove_column :districts, :title
  end
end
