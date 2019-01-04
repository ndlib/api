Capistrano::Configuration.instance(:must_exist).load do
  namespace :memcached do
    desc "Flush memcached"
    task :clear, :roles => :app do
      puts "Clearing Memcached"
      run "cd #{current_path}; #{bundler} exec #{rake} RAILS_ENV=#{rails_env} cache:clear"
    end

    task :prime, :roles => :app do 
      puts "Priming cache"
      run "cd #{current_path}; #{bundler} exec #{rake} RAILS_ENV=#{rails_env} cache:prime"
    end
  end

  before 'memcached:clear', 'env:set_paths'
  before 'memcached:prime', 'env:set_paths'  

  # after "deploy:update_code", "memcached:clear"
end