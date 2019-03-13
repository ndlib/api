class Discovery2::Holdings::Request
  attr_reader :record_id

  def initialize(record_id)
    @record_id = record_id
  end

  def requestable?
    @requestable ||= Discovery2::Holdings::Requestable.call(record_id)
  end

  def holdings
    if requestable?
      # all holding nodes with an item that has an href
      xml.xpath("get-hol-list/holdings/holding[item/@href]").collect { | node | Discovery2::Holdings::Holding.new(record_id, node) }
    else
      []
    end
  end

  private

  def response_holdings

  end

  def body
    if response
      response.body
    else
      nil
    end
  end

  def xml
    if body
      @xml ||= Nokogiri::XML(body)
    else
      nil
    end
  end

  def connection
    if @connection.nil?
      @connection = Faraday.new(:url => base_url) do |faraday|
        faraday.request  :url_encoded             # form-encode POST params
        faraday.response :logger                  # log requests to STDOUT
        faraday.adapter  Faraday.default_adapter  # make requests with Net::HTTP
      end
    end
    @connection
  end

  def base_url
    "http://aleph1-2010.library.nd.edu:1891/"
  end

  def base_path
    "/rest-dlf/record/#{base}#{doc_num}/holdings"
  end

  def url
    "#{base_url}#{base_path}?#{params.to_query}"
  end

  def params
    {
      view: 'items',
    }
  end

  def doc_num
    @doc_num ||= record_id.scan(/([0-9]*)$/).first.first
  end

  def base
    case record_id.scan(/^([a-zA-Z]*)_aleph[0-9]*/).first.first
    when 'ndu'
      'NDU01'
    when 'hcc'
      'HCC01'
    when 'smc'
      'SMC01'
    when 'bci'
      'BCI01'
    end
  end

  def response
    if !@response
      begin
        @response = send_request
      rescue Faraday::TimeoutError => e
        @response = send_request(10)
      end
    end
    @response
  end

  def success?
    response != false && !multi_object?
  end

  def send_request(timeout = 3)
    connection.get do |req|
      req.url base_path
      req.params = params
      req.options.timeout = timeout
      req.options.open_timeout = 1
    end
  end
end
