# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_mars_shoes_session',
  :secret      => '51ab0570e1e33aeacaa8ee0a32c2c9784cc32033d27c867291bf134a53759b52e80ce658a206afdbf1946962296ce8687b9f11bbbcd9848c1911aa03f521998f'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
