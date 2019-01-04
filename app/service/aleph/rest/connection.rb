require 'typhoeus/adapters/faraday'

module Aleph
  class REST
    # Establishes a connection to an external REST service
    class Connection
      attr_reader :connection_instance, :opts
      attr_accessor :request_body

      def initialize(opts = {})
        @opts = opts
        @connection_instance = establish_connection
      end

      def max_retries
        @opts[:max_retries] ||= 2
      end

      def base_url
        @opts[:base_url] ||= Rails.configuration.aleph_rest_url
      end

      def response_format
        @opts[:response_format] ||= 'xml'
      end

      # GET verb
      def get(path)
        resp = connection_instance.get(path)
        process_response(resp)
      end

      # PUT verb
      def put(path, payload)
        resp = connection_instance.put(path, payload)
        process_response(resp)
      end

      class Error < StandardError
      end

      private

      def establish_connection
        Faraday.new(url: base_url) do |conn|
          conn.request :retry, request_retry_opts
          conn.request :url_encoded
          conn.response :json, content_type: /\bjson$/
          conn.response :xml,  content_type: /\bxml$/
          conn.response :caching, ignore_params: %w(access_token) do
            file_cache
          end
          conn.adapter :typhoeus
        end
      end

      def file_cache
        cache_dir = File.join(Rails.root, '/tmp', 'cache')
        ActiveSupport::Cache::FileStore.new(
          cache_dir,
          namespace: 'ils_holds',
          expires_in: 240  # four minutes
        )
      end

      def request_retry_opts
        {
          max: max_retries,
          interval: 0.05,
          interval_randomness: 1,
          backoff_factor: 2
        }
      end

      def process_response(resp)
        type = response_content_type(resp)
        if type =~ /#{response_format}/
          resp.body.to_ostruct
        else
          fail Error, "Unexpected type (Expect #{response_format}, Not #{type})"
        end
      end

      def response_content_type(resp)
        resp.headers['Content-Type']
      end
    end
  end
end
