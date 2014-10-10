Geokit::Geocoders::request_timeout = 3

# This is your yahoo application key for the Yahoo Geocoder.
# See http://developer.yahoo.com/faq/index.html#appid
# and http://developer.yahoo.com/maps/rest/V1/geocode.html
# Geokit::Geocoders::yahoo = 'REPLACE_WITH_YOUR_YAHOO_KEY'

# This is your Google Maps geocoder key.
# See http://www.google.com/apis/maps/signup.html
# and http://www.google.com/apis/maps/documentation/#Geocoding_Examples
Geokit::Geocoders::GoogleGeocoder.api_key = 'ABQIAAAAuxm6UYepsMOkI9j2eVfKehTNjgtVgpOPWJRj2JUzDO0MbKgTnRT8uoVsFDncPmQ8CNyDQMSv0SGQJw'

# This is your username and password for geocoder.us.
# To use the free service, the value can be set to nil or false.  For
# usage tied to an account, the value should be set to username:password.
# See http://geocoder.us
# and http://geocoder.us/user/signup
# Geokit::Geocoders::geocoder_us = false

# This is your authorization key for geocoder.ca.
# To use the free service, the value can be set to nil or false.  For
# usage tied to an account, set the value to the key obtained from
# Geocoder.ca.
# See http://geocoder.ca
# and http://geocoder.ca/?register=1
# Geokit::Geocoders::geocoder_ca = false

# This is the order in which the geocoders are called in a failover scenario
# If you only want to use a single geocoder, put a single symbol in the array.
# Valid symbols are :google, :yahoo, :us, and :ca.
# Be aware that there are Terms of Use restrictions on how you can use the
# various geocoders.  Make sure you read up on relevant Terms of Use for each
# geocoder you are going to use.
Geokit::Geocoders::provider_order = [:google,:us,:ca]

# The IP provider order. Valid symbols are :ip,:geo_plugin.
# As before, make sure you read up on relevant Terms of Use for each.
Geokit::Geocoders::ip_provider_order = [:geo_plugin, :ip]
