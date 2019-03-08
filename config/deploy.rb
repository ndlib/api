# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "api"
set :repo_url, "git@github.com:ndlib/api.git"

# Default branch is :master
# ask :branch, `git rev-parse --abbrev-ref HEAD`.chomp

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, "/var/www/my_app_name"
set :deploy_to, "/home/app/api"

set :ssh_options, {
  verify_host_key: :never,
}


# Default value for keep_releases is 5
set :keep_releases, 5

# Default value for :format is :airbrussh.
# set :format, :airbrussh

# You can configure the Airbrussh format using :format_options.
# These are the defaults.
# set :format_options, command_output: true, log_file: "log/capistrano.log", color: :auto, truncate: :auto

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# append :linked_files, "config/database.yml"
set :linked_files, fetch(:linked_files, []).push("config/database.yml")
set :linked_files, fetch(:linked_files, []).push("config/secrets.yml")
set :linked_files, fetch(:linked_files, []).push("config/rest.yml")

# Default value for linked_dirs is []
# append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"
set :linked_dirs, fetch(:linked_dirs, []).push("bin", "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "solr")
# append :linked_dirs, "bin", "log", "tmp/pids", "tmp/cache", "tmp/sockets", "vendor/bundle", "public/system", "solr"

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, { path: "/opt/ruby/current/bin:$PATH" }

# set :whenever_identifier, -> { "#{fetch(:application)}_#{fetch(:stage)}" }

namespace :deploy do

  desc "Create Banner Data Symlink"
  task :banner_symlink do
    on roles(:app) do
      info "Create Banner Symlink"
      execute "ln -s /api-gateway/reserves/oit_data /home/app/api/current/banner_data"
      info "Banner Data Symlink Created"
    end
  end

  desc "Create Aleph Data Symlink"
  task :aleph_symlink do
    on roles(:app) do
      info "Create Aleph Symlink"
      execute "ln -s /api-gateway/reserves /home/app/api/current/aleph_data"
      info "Aleph Data Symlink Created"
    end
  end

  desc "Restart application"
  task :restart do
    on roles(:web), in: :sequence, wait: 5 do
      # Your restart mechanism here, for example:
      execute :touch, release_path.join("tmp/restart.txt")
    end
  end

  # desc "Reload the Solr configuration"
  # task :reload_solr_core do
  #   on roles(:app) do
  #     solr_yml = YAML.load_file("config/sunspot.yml")
  #     [rails_env.to_s].each do |solr_environment|
  #       solr_config = solr_yml[solr_environment]['solr']
  #       core_url = "http://#{solr_config['hostname']}:#{solr_config['port']}#{solr_config['path']}"
  #       core_regex = /[^\/]+$/
  #       core_name = core_url.match(core_regex)[0]
  #       base_solr_url = core_url.gsub(core_regex,'')
  #       reload_url = base_solr_url + "admin/cores?action=RELOAD&core=" + core_name
  #       puts "Reloading solr core: #{reload_url}"
  #       run "curl -I -A \"Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.0)\" \"#{reload_url}\""
  #     end
# #   end

  after :published, :restart

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, "cache:clear"
      # end
    end
  end
end

after 'deploy:finishing', 'deploy:banner_symlink', 'deploy:aleph_symlink'

# before 'deploy:reload_solr_core'

# Default value for local_user is ENV['USER']
# set :local_user, -> { `git config user.name`.chomp }

# Uncomment the following to require manually verifying the host key before first deploy.
# set :ssh_options, verify_host_key: :secure
