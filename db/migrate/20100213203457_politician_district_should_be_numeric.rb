class PoliticianDistrictShouldBeNumeric < ActiveRecord::Migration
  def self.up
    add_column :politicians, :district_number, :integer
    Politician.all.each do |politician|
      district = politician.district.to_i
      politician.update_attribute(:district_number, district == 0 ? nil : district)
    end
    remove_column :politicians, :district
    rename_column :politicians, :district_number, :district
  end

  def self.down
    change_column :politicians, :district, :string
  end
end
