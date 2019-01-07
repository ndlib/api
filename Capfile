# load 'deploy' if respond_to?(:namespace) # cap2 differentiator
# Load DSL and set up stages
require "capistrano/setup"

# Include default deployment tasks
require "capistrano/deploy"
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

# Include rails specific tasks
require "capistrano/rails"

require "whenever/capistrano"

# NOTE: The default capistrano asset tasks are not executed with bundler
# Uncomment if you are using Rails' asset pipeline
# load 'deploy/assets'

# Dir['vendor/gems/*/recipes/*.rb','vendor/plugins/*/recipes/*.rb'].each { |plugin| load(plugin) }

# Add the lib directory to the load path
# $:.unshift File.join(File.dirname(__FILE__),'lib')
# require 'hesburgh_infrastructure/capistrano'

load 'config/deploy' # remove this line to skip loading any of the default tasks
