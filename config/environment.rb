# Be sure to restart your server when you modify this file

# Uncomment below to force Rails into production mode when
# you don't control web/app server and can't set it the proper way
# ENV['RAILS_ENV'] ||= 'production'

# Specifies gem version of Rails to use when vendor/rails is not present
RAILS_GEM_VERSION = '2.2.2' unless defined? RAILS_GEM_VERSION

# Bootstrap the Rails environment, frameworks, and default configuration
require File.join(File.dirname(__FILE__), 'boot')

Rails::Initializer.run do |config|
  #require 'albino'
  
  config.time_zone = 'UTC'

  # Your secret key for verifying cookie session data integrity.
  # If you change this key, all old sessions will become invalid!
  # Make sure the secret is at least 30 characters and all random, 
  # no regular words or you'll be exposed to dictionary attacks.
  config.action_controller.session = {
    :session_key => '_pasteit_session',
    :secret      => '5b5d280ac86c63af1caefe298a625b77ca1e85a9ee06cac2b0bbfbbfaf4ee3f3db13ed2dd95d407e1bd5c4a41fcd6204ff55c46786a7e3a2cf964765e6299c1f'
  }

  #config.cache_store = :mem_cache_store


end

require "will_paginate" 
require 'albino'
require 'searchable'





