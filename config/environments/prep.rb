Api::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = false
  config.action_controller.perform_caching = true
  config.cache_store = :dalli_store, '127.0.0.1:11211', { compress: true, expires_in: 1.day}

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_files = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  config.eager_load = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = false

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)
  # config.assets.precompile += %w( search.js )

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  config.action_mailer.default_url_options = { :host => 'api-prep.lc.nd.edu' }

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # API backends
  config.api_backend_availability = "https://factotum-prep.library.nd.edu/utilities/availability/hours/api?codes=<<codes>>&date=<<date>>"
  config.api_backend_maps = "https://factotum-prep.library.nd.edu/utilities/maps/api.json"
  config.api_backend_staff_directory = "https://factotum-prep.library.nd.edu/directory/api/<<type>>/json/<<identifier>>/<<id>>"

  config.banner_dir = Rails.root.join('banner_data', 'ereserve_extract').to_s
  config.banner_archive_dir = Rails.root.join('banner_data', 'ereserve_extract').to_s

  config.print_reserves_file = Rails.root.join('aleph_data', 'prep', 'z108_data.csv').to_s

  config.enrollment_file = Rails.root.join('spec', 'fixtures', 'oit_data', 'enrollment.tsv').to_s
  config.crosslists_file = Rails.root.join('spec', 'fixtures', 'oit_data', 'crosslists.tsv').to_s
  config.print_reserves_file = Rails.root.join('spec', 'fixtures', 'aleph_data', 'z108_data.csv').to_s
  config.supersections_file = Rails.root.join('spec', 'fixtures', 'oit_data', 'supersections.tsv').to_s
  config.coursetitles_file = Rails.root.join('spec', 'fixtures', 'oit_data', 'coursetitles.tsv').to_s

  config.aleph_course_reserves = "https://aleph23-prod.lc.nd.edu/X?op=find&code=CNO&request=<<course_id>>&base=NDU30"
  config.aleph_reserve_items = "https://aleph23-prod.lc.nd.edu/X?op=present&set_entry=<<item_number>>&set_number=<<set_id>>&base=NDU30"
  config.aleph_reserve_item_status = "https://aleph23-prod.lc.nd.edu/X?op=circ_status&library=NDU30&sys_no=<<doc_number>>"
  config.aleph_rest_url = "http://aleph23-prod.lc.nd.edu:1891/"

end
