Transform /location is "([^\"]*)"/ do |address|
  city, state, zip = address.match(/(.+), ([A-Z]{2}) (\d{5})/).captures
  Geokit::GeoLoc.new(:city => city, :state => state, :zip => zip, :country_code => 'US').tap do |loc|
    loc.success = true
  end
end

Given /^my (location is "[^"]*")$/ do |address|
  mock(Geokit::Geocoders::MultiGeocoder).geocode(anything) { address }
end
