module Aleph
  # An interface for communicating with the Aleph REST API
  class REST
    attr_reader :connection
    attr_accessor :verb, :path, :payload

    def initialize(opts = {})
      @opts = opts
      @connection ||= Aleph::REST::Connection.new(opts)
      @verb = set_verb
      @path = set_path
    end

    def transact
      if payload
        @connection.send(verb, path, payload)
      else
        @connection.send(verb, path)
      end
    end

    private

    def set_verb
      if @opts[:verb]
        @opts[:verb]
      else
        'get'
      end
    end

    def set_path
      if @opts[:path]
        @opts[:path]
      else
        '/'
      end
    end
  end
end
