Transform /location is "([^\"]*)"/ do |address|
  city, state, zip = address.match(/(.+), ([A-Z]{2}) (\d{5})/).captures
  Geokit::GeoLoc.new(:city => city, :state => state, :zip => zip, :country_code => 'US').tap do |loc|
    loc.success = true
  end
end

Given /^my (location is "[^"]*")$/ do |address|
  mock(Geokit::Geocoders::MultiGeocoder).geocode(anything) { address }
end

Given /^my location is set to "([^"]*)"/ do |zip|
  mock(District).lookup(anything) { [create_district(:level => 'federal'), create_district] }
  visit new_location_path
  fill_in 'Location', :with => zip
  click_button 'Set'
end
