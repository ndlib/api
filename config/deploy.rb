require './lib/deploy/memcached'
require './lib/deploy/whenever'

begin
  # require 'new_relic/recipes'

  after "deploy:update", "newrelic:notice_deployment"
rescue LoadError
end

# Set the name of the application.  This is used to determine directory paths and domains
set :application, 'api'

#############################################################
#  Application settings
#############################################################

# Defaults are set in lib/hesburgh_infrastructure/capistrano/common.rb

# Repository defaults to "git@git.library.nd.edu:#{application}"
# set :repository, "git@git.library.nd.edu:myrepository"

# Define symlinks for files or directories that need to persist between deploys.
# /log, /vendor/bundle, and /config/database.yml are automatically symlinked
# set :application_symlinks, ["/path/to/file"]
set :application_symlinks, [
  { '/oit_data' => '/banner_data' },
  '/aleph_data',
  "/config/secrets.yml",
  "/config/rest.yml",
  "/config/database.yml",
  # not currently in use
  # { '/vendor/bundle/bin/packet_worker_runner' => '/vendor/bundle/ruby/1.9.1/bin/packet_worker_runner' }
]



#############################################################
#  Environment settings
#############################################################

# Defaults are set in lib/hesburgh_infrastructure/capistrano/environments.rb

set :scm, "git"
set :scm_command, '/usr/bin/git'

set :user, 'app'
set :ruby_bin, "/opt/ruby/current/bin"


desc "Setup for the Pre-Production environment"
task :pre_production do
  # Customize pre_production configuration
  set :deploy_to, "/home/app/#{application}"
  set :domain, "apipprd.library.nd.edu"

  set :branch, 'attempt_to_add_modules'
end

desc "Setup for the Prep environment"
task :prep do
  # Customize pre_production configuration
  set :deploy_to, "/home/app/#{application}"
  set :domain, "api-prep.lc.nd.edu"

  set :branch, 'attempt_to_add_modules'
end

desc "Setup for the production environment"
task :production do
  # Customize pre_production configuration
  set :deploy_to, "/home/app/#{application}"
  set :domain, "api.library.nd.edu"

end

#############################################################
#  Additional callbacks and tasks
#############################################################

# Define any addional tasks or callbacks here

namespace :deploy do

  desc "Reload the Solr configuration"
  task :reload_solr_core, :roles => :app do
    solr_yml = YAML.load_file("config/sunspot.yml")
    [rails_env.to_s].each do |solr_environment|
      solr_config = solr_yml[solr_environment]['solr']
      core_url = "http://#{solr_config['hostname']}:#{solr_config['port']}#{solr_config['path']}"
      core_regex = /[^\/]+$/
      core_name = core_url.match(core_regex)[0]
      base_solr_url = core_url.gsub(core_regex,'')
      reload_url = base_solr_url + "admin/cores?action=RELOAD&core=" + core_name
      puts "Reloading solr core: #{reload_url}"
      run "curl -I -A \"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)\" \"#{reload_url}\""
    end
  end
end

before 'deploy:cleanup', 'deploy:reload_solr_core'

