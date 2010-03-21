# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_ibc_session',
  :secret      => 'cab53769489bef4e9f3e88723fc4c4e9d47967fa936d1bcd7461604f9040dc5a1417e1cd0969515a87dbc238d3289bc38337ca3b008745da0852cf07af8aab11'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
