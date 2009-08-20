ENV['RAILS_ENV'] ||= 'production'
# Be sure to restart your server when you modify this file
# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION
SNORBY_VERSION = '1.1.2'

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  
  config.load_paths << "#{RAILS_ROOT}/app/sweepers"
  config.time_zone = 'UTC'
  
  config.action_controller.page_cache_directory = RAILS_ROOT + "/public/cache/"
  
  config.gem 'mislav-will_paginate', :version => '~> 2.3.8', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem "authlogic"
  config.gem "chronic"
  config.gem 'javan-whenever', :lib => false, :source => 'http://gems.github.com'
  config.gem "prawn"
  config.gem "mattetti-googlecharts", :lib => "gchart", :source => "http://gems.github.com/"
  config.gem "ambethia-smtp-tls", :lib => "smtp-tls", :source => "http://gems.github.com/"
  config.gem "composite_primary_keys"
end

require 'ipaddr'
require 'resolv'