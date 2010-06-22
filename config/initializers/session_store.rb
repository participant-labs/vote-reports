# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_vote-reports_session-1',
  :secret      => '3be04689bc4eca9707ff66af8927ee3e4380aef4a99ffd694afc3b10b20045a89d7d27b343b788ff487cd2ca2226270c5bf48d1f1659bea3047c3747fd393236'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
require 'mongo_session_store/mongo_mapper'
ActionController::Base.session_store = :mongo_mapper_store
