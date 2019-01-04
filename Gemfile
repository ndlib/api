source 'http://rubygems.org'

gem 'rails', '~> 4.2'

# Bundle edge Rails instead:
# gem 'rails', :git => 'git://github.com/rails/rails.git'

gem 'dalli' #memcache
gem 'devise'
gem 'devise_cas_authenticatable'
gem 'devise-token_authenticatable'
gem 'exlibris-primo'
gem "hesburgh_infrastructure", git: 'git@git.library.nd.edu:hesburgh_infrastructure'

#check to see if there is a version above 2.4.0.
# this was added to bc there is a fix in master for cyrillic characters that has not been released.
gem 'nori', git: 'https://github.com/savonrb/nori.git', ref: '3a9cdb63e624430b970ef48a641d8622840ebbbc'
gem 'jquery-rails'
gem 'mysql2', '~> 0.4.4' #, '<= 0.3.19'
# gem 'activerecord-mysql2-adapter'
gem 'net-ldap'
gem 'rack-jsonp-middleware'
gem 'savon' #, '~> 2.5.0'
gem "whenever", :require => false
gem 'icalendar'
gem 'sunspot_rails', '2.3.0' # '<= 2.1.1'
gem 'rsolr' #, '1.0.7'
gem 'colored'
gem "rb-readline"
gem "faraday"
gem "faraday_middleware"
gem "multi_xml"
gem "excon"
gem 'typhoeus'
gem 'virtus'

# To see indexing progress
gem 'progress_bar'

# Server monitoring
# gem 'newrelic_rpm'

gem 'addressable'

# Sentry.io integration
gem "sentry-raven"

gem "public_suffix"

# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails' #,   '~> 3.2.3'
  gem 'coffee-rails' #, '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby

  gem 'uglifier', '>= 1.0.3'
end

group :development, :test do
  gem 'activerecord-nulldb-adapter'
  gem 'ruby-prof'

#  gem "debugger", '~> 1.6.6'
  gem "rspec-rails" #, '~> 3.2.0'
  gem "capybara"
  gem "factory_girl_rails", :require => false
  gem "faker"

#  gem "guard"
#  gem "guard-bundler"
#  gem "guard-coffeescript"
#  gem "guard-rails"
#  gem "guard-rspec"
#  gem "guard-spork"
  gem "spork" # , '~> 1.0rc', :git => "git://github.com/ndlib/spork.git", :branch => 'rspec3_runner'
  gem 'sunspot_solr', '<= 2.3.0' # optional pre-packaged Solr distribution for use in development

  gem 'railroady' # generate class diagrams
  gem 'umlify' # generate class based uml diagrams
end

group :test do
  gem 'database_cleaner', '~> 1.6.2'

#  gem 'growl-rspec'
  gem 'json_spec'

  gem 'vcr'
  gem 'webmock'
end
