# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_services_session',
  :secret      => 'd39a471c1fad1926aae90f7acf1e34ed6fd50147d6f69059389605c9b42ef7669ee61a25c7961dba31bbe8a780c58a715a7aa4505ea1cf0cc48e354a09b3c8bd'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
