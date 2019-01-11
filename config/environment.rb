# Load the rails application
require File.expand_path('../application', __FILE__)

# Sentry
require "raven/base"
require "raven/integrations/rails"

# Initialize the rails application
#Api::Application.initialize!
Rails.application.initialize!
