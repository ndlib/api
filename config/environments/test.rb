Api::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # The test environment is used exclusively to run your application's
  # test suite. You never need to work with it otherwise. Remember that
  # your test database is "scratch space" for the test suite and is wiped
  # and recreated between test runs. Don't rely on the data there!
  config.cache_classes = !(ENV['DRB'] == 'true')

  # Configure static asset server for tests with Cache-Control for performance
  config.serve_static_files = true
  config.static_cache_control = "public, max-age=3600"
  config.eager_load = false
  # Log error messages when you accidentally call methods on nil
  config.whiny_nils = true

  # default host name for testing
  Rails.application.routes.default_url_options[:host] = 'test.host'

  # Log level
  config.log_level = :debug

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  # config.action_controller.perform_caching = false
  config.action_controller.perform_caching = false
  #config.cache_store = :dalli_store, '127.0.0.1:11211', { compress: true, expires_in: 1.day}

  # Raise exceptions instead of rendering exception templates
  config.action_dispatch.show_exceptions = false

  # Disable requests forgery protection in test environment
  config.action_controller.allow_forgery_protection    = false

  # Tell Action Mailer not to deliver emails to the real world.
  # The :test delivery method accumulates sent emails in the
  # ActionMailer::Base.deliveries array.
  config.action_mailer.delivery_method = :test

  # Raise exception on mass assignment protection for Active Record models
  # config.active_record.mass_assignment_sanitizer = :strict

  # Print deprecation notices to the stderr
  config.active_support.deprecation = :stderr

  # API backends
  config.api_backend_availability = "http://test.host/utilities/availability/hours/api?codes=<<codes>>&date=<<date>>"
  config.api_backend_maps = "http://test.host/utilities/maps/api.json"
  config.api_backend_staff_directory = "http://library.nd.edu/directory/api/<<type>>/json/<<identifier>>/<<id>>"
  config.enrollment_file = Rails.root.join('spec', 'fixtures', 'oit_data', 'enrollment.tsv').to_s
  config.crosslists_file = Rails.root.join('spec', 'fixtures', 'oit_data', 'crosslists.tsv').to_s
  config.print_reserves_file = Rails.root.join('spec', 'fixtures', 'aleph_data', 'z108_data.csv').to_s
  config.supersections_file = Rails.root.join('spec', 'fixtures', 'oit_data', 'supersections.tsv').to_s
  config.coursetitles_file = Rails.root.join('spec', 'fixtures', 'oit_data', 'coursetitles.tsv').to_s
  config.aleph_course_reserves = "http://alephprod.library.nd.edu:8991/X?op=find&code=CNO&request=<<course_id>>&base=NDU30"
  config.aleph_reserve_items = "http://alephprod.library.nd.edu:8991/X?op=present&set_entry=<<item_number>>&set_number=<<set_id>>&base=NDU30"
  config.aleph_reserve_item_status = "http://alephprod.library.nd.edu:8991/X?op=circ_status&library=NDU30&sys_no=<<doc_number>>"
  config.aleph_rest_url = "http://paul.library.nd.edu:1891/"
end

