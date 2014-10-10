class CleanUpDistricts < ActiveRecord::Migration
  def self.district_for_politician(politician)
    case politician.to_param
    when 'ed-case'
      UsState.find_by_full_name('Hawaii').districts.find_by_district(2)
    when 'rahm-emanuel'
      UsState.find_by_full_name('Illinois').districts.find_by_district(5)
    when 'jo-ann-emerson'
      UsState.find_by_full_name('Missouri').districts.find_by_district(8)
    when 'robert-matsui'
      UsState.find_by_full_name('California').districts.find_by_district(5)
    when 'julian-dixon'
      UsState.find_by_full_name('California').districts.find_by_district(32)
    when 'newton-gingrich'
      UsState.find_by_full_name('Georgia').districts.find_by_district(6)
    end
  end

  def self.up
    $stdout.sync = true
    District.paginated_each(:conditions => {:district => -1}) do |district|
      proper_district = District.find_or_create_by(us_state_id: district.us_state_id, district: 0)
      raise "Missing district" unless proper_district.present?
      district.representative_terms.update_all(:district_id => proper_district)
      district.cached_politicians.update_all(:district_id => proper_district)
      district.zip_codes.update_all(:district_id => proper_district)
      $stdout.print '.'
    end
    $stdout.puts
    District.paginated_each(:conditions => {:district => 99}) do |district|
      unless district.state.abbreviation == 'NE'
        raise "Unexpected 99 district from #{district.state.abbreviation}"
      end
      proper_district = UsState.find_by_abbreviation('NE').districts.find_by_district(2)
      raise "Missing district" unless proper_district.present?
      district.representative_terms.update_all(:district_id => proper_district)
      district.cached_politicians.update_all(:district_id => proper_district)
      district.zip_codes.update_all(:district_id => proper_district)
      $stdout.print '.'
    end
    $stdout.puts
    District.paginated_each(:conditions => {:district => nil}) do |district|
      district.representative_terms.each do |term|
         proper_district = district_for_politician(term.politician)
         raise "Missing district" unless proper_district.present?
         term.update_attributes(:district => proper_district)
       end
      district.cached_politicians.each do |politician|
         proper_district = district_for_politician(politician)
         raise "Missing district" unless proper_district.present?
         politician.update_attributes(:district => proper_district)
       end
      $stdout.print '.'
    end
    $stdout.puts
    District.delete_all(:district => nil)
    District.delete_all(:district => 99)
    District.delete_all(:district => -1)
    change_column :districts, :district, :integer, :null => false
    constrain :districts, :district, :within => 0..53
  end

  def self.down
    raise "nope"
  end
end
