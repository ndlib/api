class ExternalRest
  attr_reader :connection
  attr_accessor :verb, :path, :payload

  def initialize(base_url: nil, verb: 'get', path: '/', connection_opts: {})
    @connection ||= ExternalRestConnection.new(base_url: base_url, connection_opts: connection_opts)
    @verb = verb
    @path = path
  end

  def transact
    if payload
      @connection.send(verb, path, payload)
    else
      @connection.send(verb, path)
    end
  end

end
