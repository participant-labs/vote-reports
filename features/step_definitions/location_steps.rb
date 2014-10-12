Transform /location is "([^\"]*)"/ do |address|
  city, state, zip = address.match(/(.+), ([A-Z]{2}) (\d{5})/).captures
  Geokit::GeoLoc.new(city: city, state: state, zip: zip, country_code: 'US', lat: '33.0146', lng: '-97.0970').tap do |loc|
    loc.success = true
  end
end

Given /^my (location is "[^"]*")$/ do |address|
  allow(Geokit::Geocoders::MultiGeocoder).to receive(:geocode).and_return(address)
end

Given /^my location is assured(?: to "([^"]*)")?$/ do |congressional_district|
  ActiveRecord::Fixtures.reset_cache
  ActiveRecord::Fixtures.create_fixtures(Rails.root.join('spec/fixtures'), ['districts', 'congressional_districts', 'us_states'])
  allow(District).to receive(:lookup) { District.all }

  if congressional_district
    state, district_number = congressional_district.split('-')
    state = UsState.find_by_abbreviation!(state)
    District.find_each do |district|
      district.update_attributes!(state: state, name: district_number)
    end
  else
    state = UsState.all.sample
    District.update_all(us_state_id: state.id)
  end
end

Given /^my location is set to "([^"]*)"/ do |zip|
  visit new_location_path
  fill_in 'Location', with: zip
  click_button 'Set'
end
