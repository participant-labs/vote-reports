class StoreDistrictCongressionalDistrictInTheDb < ActiveRecord::Migration
  def self.up
    add_column :congressional_districts, :district_id, :integer
    add_foreign_key :congressional_districts, :districts

    say_with_time "associating districts and congressional districts" do
      District.federal.paginated_each do |district|
        name =
          case district.name
          when 'At large', '98'
            0
          else
            district.name
          end
        district.state.congressional_districts.find_by_district(name).update_attributes(:district_id => district.id)
        print '.'
      end
      puts
    end
  end

  def self.down
    raise 'Nope'
  end
end
