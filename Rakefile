#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

Api::Application.load_tasks


namespace :cache do
  desc 'Clear memcache'
  task :clear => :environment do
    puts "Clearing all the cache"
    Rails.cache.clear
  end


  desc 'Prime the cache'
  task :prime => :environment do 
    puts "Priming the cache"
    PrimeCache.prime
  end
end
