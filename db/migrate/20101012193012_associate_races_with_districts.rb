class AssociateRacesWithDistricts < ActiveRecord::Migration
  def self.up
    rename_column :races, :district, :district_name
    add_column :races, :district_id, :integer
    add_foreign_key :races, :districts

    say_with_time "Populating race district references" do
      Race.all.each do |race|
        race.populate_race_reference
        race.save!
        print '.'
      end
      puts
    end
  end

  def self.down
    raise "nope"
  end
end
