# Be sure to restart your server when you modify this file

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.3.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|

  #config.time_zone = 'Central Time (US & Canada)'
  config.time_zone = 'UTC'
  
  config.gem 'mislav-will_paginate', :version => '~> 2.3.8', :lib => 'will_paginate', :source => 'http://gems.github.com'
  config.gem('freelancing-god-thinking-sphinx', :lib => 'thinking_sphinx', :version => '1.1.22')
  
end

require 'composite_primary_keys'
require 'ipaddr'
require 'resolv'