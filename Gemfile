source 'http://rubygems.org'

group :application do
  gem 'rails', '4.2.11'
  gem 'dalli' #memcache
  # gem "hesburgh_infrastructure", git: 'git@git.library.nd.edu:hesburgh_infrastructure'

  gem 'exlibris-primo'
  gem "public_suffix"
  gem 'devise'

  # Okta
  gem 'omniauth-oktaoauth'

  gem 'devise-token_authenticatable'
  
  #check to see if there is a version above 2.4.0.
  # this was added to bc there is a fix in master for cyrillic characters that has not been released.
  # gem 'nori', git: 'https://github.com/savonrb/nori.git', ref: '3a9cdb63e624430b970ef48a641d8622840ebbbc'
  gem 'jquery-rails'
  gem 'mysql2', '~> 0.4.4' #, '<= 0.3.19'
  # gem 'activerecord-mysql2-adapter'
  gem "faraday"
  gem "faraday_middleware"
  gem 'net-ldap'
  gem 'rack-jsonp-middleware'
  gem 'savon' #, '~> 2.5.0'
  gem 'icalendar'
  gem 'rsolr' #, '1.0.7'
  gem 'colored'
  gem "rb-readline"
  gem "multi_xml"
  gem "excon"
  gem 'typhoeus'

  # To see indexing progress
  gem 'progress_bar'

  # Server monitoring
  # gem 'newrelic_rpm'

  # update nori to address issue
  gem "nori", '~> 2.5.0'

  gem 'addressable'
 
  # Sentry.io integration
  gem "sentry-raven"
  
  gem 'virtus'
  gem 'sunspot_rails', '2.3.0' # '<= 2.1.1'

  gem 'bigdecimal'
end


# Gems used only for assets and not required
# in production environments by default.
group :assets do
  gem 'sass-rails' #,   '~> 3.2.3'
  gem 'coffee-rails' #, '~> 3.2.1'

  # See https://github.com/sstephenson/execjs#readme for more supported runtimes
  gem 'therubyracer', platforms: :ruby

  gem 'uglifier', '>= 1.0.3'
end

# For deployment from a CI server
group :deployment do
  # Use Capistrano for deployment
  gem "capistrano", "~> 3.11"
  gem "capistrano-rails", "~> 1.1"
  gem "capistrano-maintenance", "~> 1.0"
  gem "whenever", :require => false
end

group :development, :test do
  gem 'activerecord-nulldb-adapter'
  gem 'ruby-prof'
  gem "rspec-rails" #, '~> 3.2.0'
  gem "spork" # , '~> 1.0rc', :git => "git://github.com/ndlib/spork.git", :branch => 'rspec3_runner'
  gem "capybara"
  gem "factory_girl_rails", :require => false
  gem "faker"
  gem 'sunspot_solr', '<= 2.3.0' # optional pre-packaged Solr distribution for use in development
  gem 'railroady' # generate class diagrams
  gem 'umlify' # generate class based uml diagrams
end

group :test do
  gem 'database_cleaner', '~> 1.6.2'
  gem 'json_spec'
  gem 'vcr'
  gem 'webmock'
end
