module VCRSetup
  def self.configure_vcr
    # VCR is used to 'record' HTTP interactions with
    # third party services used in tests, and play em
    # back. Useful for efficiency, also useful for
    # testing code against API's that not everyone
    # has access to -- the responses can be cached
    # and re-used.
    require 'vcr'
    require 'webmock/rspec'

    # To allow us to do real HTTP requests in a VCR.turned_off, we
    # have to tell webmock to let us.
    # WebMock.allow_net_connect!(:net_http_connect_on_start => true)

    VCR.configure do |c|
      c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
      c.hook_into :webmock
      c.allow_http_connections_when_no_cassette = false
      c.ignore_hosts (
        'alephpprd.library.nd.edu'
      )
    end
  end
end
