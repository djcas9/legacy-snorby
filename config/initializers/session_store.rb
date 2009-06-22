# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_snorby_session',
  :secret      => 'd350b244e225eb8bc0eb680e9a36f2735bbf6e6f448ea25eeb82dbd650d287de1ad54b4845cfcbbbd0d97cd7e3bccff2252cf37e5a45a45dadc081ae7d7bfbef'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store
